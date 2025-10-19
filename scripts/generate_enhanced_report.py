#!/usr/bin/env python3
"""
Script para generar reporte HTML mejorado a partir de archivos .jtl de JMeter
Autor: Performance Testing Team
VersiÃ³n: 1.0
"""

import csv
import json
import os
import sys
from datetime import datetime
from pathlib import Path
import argparse

def parse_jtl_file(jtl_file):
    """Parsea un archivo .jtl y extrae las mÃ©tricas principales"""
    data = {
        'endpoints': {},
        'total_samples': 0,
        'total_errors': 0,
        'response_times': [],
        'throughput_data': [],
        'time_series': {
            'labels': [],
            'avg_response': [],
            'concurrent_users': [],
            'throughput': []
        },
        'execution_info': {
            'start_time': None,
            'end_time': None,
            'duration': 0
        }
    }
    
    try:
        with open(jtl_file, 'r', encoding='utf-8') as file:
            reader = csv.DictReader(file)
            
            BUCKET_MS = 15000
            buckets = {}

            for row in reader:
                label = (row.get('label', '') or '').strip()
                # Ignorar muestras sin etiqueta (suelen ser subresultados o líneas vacías)
                if not label:
                    continue
                elapsed = int(row.get('elapsed', 0))
                success = row.get('success', 'true').lower() == 'true'
                # Filtrar ruido: muestras exitosas con 0 ms no aportan y sesgan métricas
                if success and elapsed <= 0:
                    continue
                timestamp = int(row.get('timeStamp', 0))
                all_threads = int(row.get('allThreads', 0) or 0)
                
                data['total_samples'] += 1
                if not success:
                    data['total_errors'] += 1
                
                data['response_times'].append(elapsed)
                
                if label not in data['endpoints']:
                    data['endpoints'][label] = {
                        'samples': 0,
                        'errors': 0,
                        'response_times': [],
                        'success_rate': 0
                    }
                
                data['endpoints'][label]['samples'] += 1
                data['endpoints'][label]['response_times'].append(elapsed)
                if not success:
                    data['endpoints'][label]['errors'] += 1
                
                if data['execution_info']['start_time'] is None:
                    data['execution_info']['start_time'] = timestamp
                data['execution_info']['end_time'] = timestamp

                if data['execution_info']['start_time'] is not None:
                    start = data['execution_info']['start_time']
                    idx = (timestamp - start) // BUCKET_MS
                    b = buckets.setdefault(idx, {'sum_rt': 0, 'count': 0, 'max_users': 0, 'rts': []})
                    b['sum_rt'] += elapsed
                    b['count'] += 1
                    b['rts'].append(elapsed)
                    if all_threads > b['max_users']:
                        b['max_users'] = all_threads
            
            for label, endpoint_data in data['endpoints'].items():
                response_times = endpoint_data['response_times']
                if response_times:
                    response_times.sort()
                    n = len(response_times)
                    
                    endpoint_data['avg'] = sum(response_times) / n
                    endpoint_data['min'] = min(response_times)
                    endpoint_data['max'] = max(response_times)
                    endpoint_data['p50'] = response_times[int(n * 0.5)]
                    endpoint_data['p90'] = response_times[int(n * 0.9)]
                    endpoint_data['p95'] = response_times[int(n * 0.95)]
                    endpoint_data['p99'] = response_times[int(n * 0.99)]
                    endpoint_data['success_rate'] = ((endpoint_data['samples'] - endpoint_data['errors']) / endpoint_data['samples']) * 100
                    
                    if endpoint_data['p95'] < 500:
                        endpoint_data['status'] = 'ok'
                    elif endpoint_data['p95'] < 2000:
                        endpoint_data['status'] = 'warn'
                    else:
                        endpoint_data['status'] = 'danger'
            
            if data['response_times']:
                data['response_times'].sort()
                n = len(data['response_times'])
                data['avg_response'] = sum(data['response_times']) / n
                data['p95_response'] = data['response_times'][int(n * 0.95)]
                data['p99_response'] = data['response_times'][int(n * 0.99)]
            
            if data['execution_info']['start_time'] and data['execution_info']['end_time']:
                duration_ms = data['execution_info']['end_time'] - data['execution_info']['start_time']
                data['execution_info']['duration'] = duration_ms / 1000  # en segundos
            
            if data['execution_info']['duration'] > 0:
                data['throughput'] = data['total_samples'] / data['execution_info']['duration']
            
            T = 500
            satisfied = 0
            tolerated = 0
            total = data['total_samples']
            try:
                with open(jtl_file, 'r', encoding='utf-8') as f2:
                    rdr = csv.DictReader(f2)
                    for row2 in rdr:
                        success2 = row2.get('success', 'true').lower() == 'true'
                        if not success2:
                            continue
                        t = int(row2.get('elapsed', 0))
                        if t <= 0:
                            continue
                        if t < T:
                            satisfied += 1
                        elif t < 3*T:
                            tolerated += 1
                data['apdex'] = ((satisfied + 0.5 * tolerated) / total) if total > 0 else 0.0
            except Exception:
                data['apdex'] = 0.0
            
            data['success_rate'] = ((data['total_samples'] - data['total_errors']) / data['total_samples']) * 100

            if buckets:
                start = data['execution_info']['start_time']
                labels = []
                avg_rt = []
                conc = []
                thr = []
                p95 = []
                p99 = []
                for idx in sorted(buckets.keys()):
                    ts = start + idx*BUCKET_MS
                    labels.append(datetime.fromtimestamp(ts/1000).strftime('%H:%M:%S'))
                    b = buckets[idx]
                    avg_rt.append(round(b['sum_rt']/b['count'], 2) if b['count'] else 0)
                    conc.append(b['max_users'])
                    thr.append(round(b['count']/(BUCKET_MS/1000), 3))
                    if b['rts']:
                        rts_sorted = sorted(b['rts'])
                        n = len(rts_sorted)
                        p95.append(rts_sorted[int(min(n-1, max(0, n*0.95)))])
                        p99.append(rts_sorted[int(min(n-1, max(0, n*0.99)))])
                    else:
                        p95.append(0)
                        p99.append(0)
                data['time_series'] = {
                    'labels': labels,
                    'avg_response': avg_rt,
                    'concurrent_users': conc,
                    'throughput': thr,
                    'p95': p95,
                    'p99': p99
                }
            
    except Exception as e:
        print(f"Error al procesar archivo {jtl_file}: {e}")
        return None
    
    return data

def generate_html_report(data, jtl_file, output_file):
    """Genera el reporte HTML con los datos procesados"""

    template_file = Path(__file__).parent.parent / 'templates' / 'jpetstore_custom_report.html'
    if not template_file.exists():
        print(f"Error: Template no encontrado en {template_file}")
        return False

    with open(template_file, 'r', encoding='utf-8') as f:
        html_content = f.read()

    endpoints_data = []
    for label, endpoint_data in data['endpoints'].items():
        if not endpoint_data.get('response_times'):
            continue
        endpoints_data.append({
            'name': label,
            'avg': round(endpoint_data.get('avg', 0)),
            'p95': round(endpoint_data.get('p95', 0)),
            'p99': round(endpoint_data.get('p99', 0)),
            'status': endpoint_data.get('status', 'ok')
        })

    exec_info = data.get('execution_info', {})
    start_ms = exec_info.get('start_time')
    end_ms = exec_info.get('end_time')
    if start_ms and end_ms:
        start_dt = datetime.fromtimestamp(start_ms / 1000)
        end_dt = datetime.fromtimestamp(end_ms / 1000)
        execution_date = f"{start_dt.strftime('%d/%m/%Y %H:%M')} - {end_dt.strftime('%H:%M')}"
    else:
        execution_date = datetime.now().strftime('%d/%m/%Y %H:%M')

    test_data = {
        'executionDate': execution_date,
        'sourceFile': os.path.basename(jtl_file),
        'apdex': round(data.get('apdex', 0.0), 3),
        'successRate': round(data.get('success_rate', 0.0), 1),
        'avgResponse': round(data.get('avg_response', 0.0), 0),
        'throughput': float(f"{data.get('throughput', 0.0):.6f}"),
        'totalSamples': data.get('total_samples', 0),
        'endpoints': endpoints_data,
        'timeSeries': {
            'labels': data.get('time_series', {}).get('labels', []),
            'avgResponse': data.get('time_series', {}).get('avg_response', []),
            'concurrentUsers': data.get('time_series', {}).get('concurrent_users', []),
            'throughput': data.get('time_series', {}).get('throughput', []),
        },
        'testConfig': {
            'users': '-',
            'duration': exec_info.get('duration', 0),
            'rampup': '-',
            'url': '-'
        }
    }

    js_data = "let testData = " + json.dumps(test_data, ensure_ascii=False) + ";"

    if '// __TEST_DATA__' in html_content:
        html_content = html_content.replace('// __TEST_DATA__', js_data)
    else:
        html_content = html_content.replace('<script>', '<script>\n' + js_data + '\n', 1)

    try:
        with open(output_file, 'w', encoding='utf-8') as f:
            f.write(html_content)
        return True
    except Exception as e:
        print(f"Error al escribir archivo {output_file}: {e}")
        return False

def main():
    parser = argparse.ArgumentParser(description='Generar reporte HTML mejorado desde archivo .jtl')
    parser.add_argument('jtl_file', help='Archivo .jtl de JMeter')
    parser.add_argument('-o', '--output', help='Archivo HTML de salida', default=None)
    parser.add_argument('-v', '--verbose', action='store_true', help='Modo verbose')
    
    args = parser.parse_args()
    
    if not os.path.exists(args.jtl_file):
        print(f"Error: Archivo {args.jtl_file} no encontrado")
        sys.exit(1)
    
    if args.output is None:
        jtl_path = Path(args.jtl_file)
        output_file = jtl_path.parent / f"reporte_enhanced_{jtl_path.stem}.html"
    else:
        output_file = args.output
    
    if args.verbose:
        print(f"Procesando archivo: {args.jtl_file}")
        print(f"Archivo de salida: {output_file}")
    
    data = parse_jtl_file(args.jtl_file)
    if data is None:
        print("Error al procesar el archivo .jtl")
        sys.exit(1)
    
    if args.verbose:
        print(f"Procesadas {data['total_samples']} muestras")
        print(f"Tasa de Ã©xito: {data['success_rate']:.1f}%")
        print(f"APDEX: {data['apdex']:.3f}")
        print(f"Throughput: {data['throughput']:.2f} req/s")
    
    if generate_html_report(data, args.jtl_file, output_file):
        print(f"âœ… Reporte generado exitosamente: {output_file}")
        print(f"ðŸ“Š Abre el archivo en tu navegador para ver los resultados")
    else:
        print("âŒ Error al generar el reporte")
        sys.exit(1)

if __name__ == '__main__':
    main()



