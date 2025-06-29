from flask import Flask, Response, render_template, request, jsonify
import requests
from lxml import etree
import json

app = Flask(__name__)

def obtener_xml_data():
    """Función auxiliar para obtener y parsear el XML"""
    url = 'https://data.ct.gov/api/views/jfhb-ebu6/rows.xml?accessType=DOWNLOAD'
    response = requests.get(url)
    return etree.fromstring(response.content)

@app.route('/')
def home():
    # Obtener XML desde la URL
    xml_data = obtener_xml_data()

    # Cargar el XSLT desde archivo local
    xslt_path = 'static/estilos.xslt'
    xslt_doc = etree.parse(xslt_path)
    transform = etree.XSLT(xslt_doc)

    # Aplicar transformación
    resultado = transform(xml_data)

    # Mostrar HTML generado
    return Response(str(resultado), mimetype='text/html')

@app.route('/filtrar')
def filtrar():
    # Obtener parámetros de filtro
    nombre = request.args.get('nombre', '').lower()
    direccion = request.args.get('direccion', '').lower()
    ciudad = request.args.get('ciudad', '')
    horario = request.args.get('horario', '')
    ev_nivel1 = request.args.get('ev_nivel1', '')
    ev_nivel2 = request.args.get('ev_nivel2', '')
    fast_charge = request.args.get('fast_charge', '')

    xml_data = obtener_xml_data()

    # Construir XPath dinámico basado en los filtros
    xpath_conditions = []
    
    if nombre:
        xpath_conditions.append(f'contains(translate(station_name, "ABCDEFGHIJKLMNOPQRSTUVWXYZ", "abcdefghijklmnopqrstuvwxyz"), "{nombre}")')
    
    if direccion:
        xpath_conditions.append(f'contains(translate(street_address, "ABCDEFGHIJKLMNOPQRSTUVWXYZ", "abcdefghijklmnopqrstuvwxyz"), "{direccion}")')
    
    if ciudad:
        xpath_conditions.append(f'city="{ciudad}"')
    
    if horario:
        xpath_conditions.append(f'access_days_time="{horario}"')
    
    if ev_nivel1:
        xpath_conditions.append(f'ev_level1_evse_num="{ev_nivel1}"')
    
    if ev_nivel2:
        xpath_conditions.append(f'ev_level2_evse_num="{ev_nivel2}"')
    
    if fast_charge:
        xpath_conditions.append(f'ev_dc_fast_count="{fast_charge}"')

    # Si no hay filtros, mostrar todos
    if not xpath_conditions:
        filas_filtradas = xml_data.xpath('//row/row')
    else:
        xpath_query = '//row/row[' + ' and '.join(xpath_conditions) + ']'
        filas_filtradas = xml_data.xpath(xpath_query)

    # Crear nuevo árbol XML con solo las filas filtradas
    nuevo_root = etree.Element("response")
    for fila in filas_filtradas:
        contenedor = etree.Element("row")
        contenedor.append(fila)
        nuevo_root.append(contenedor)

    # Aplicar transformación
    xslt_doc = etree.parse('static/estilos.xslt')
    transform = etree.XSLT(xslt_doc)
    resultado = transform(nuevo_root)

    return Response(str(resultado), mimetype='text/html')

@app.route('/api/opciones')
def obtener_opciones():
    """Endpoint para obtener opciones únicas para los filtros de combobox"""
    xml_data = obtener_xml_data()
    
    # Extraer valores únicos para cada campo
    ciudades = set()
    horarios = set()
    ev_nivel1 = set()
    ev_nivel2 = set()
    fast_charges = set()
    
    for row in xml_data.xpath('//row/row'):
        ciudad = row.find('city')
        if ciudad is not None and ciudad.text:
            ciudades.add(ciudad.text)
            
        horario = row.find('access_days_time')
        if horario is not None and horario.text:
            horarios.add(horario.text)
            
        nivel1 = row.find('ev_level1_evse_num')
        if nivel1 is not None and nivel1.text:
            ev_nivel1.add(nivel1.text)
            
        nivel2 = row.find('ev_level2_evse_num')
        if nivel2 is not None and nivel2.text:
            ev_nivel2.add(nivel2.text)
            
        fast = row.find('ev_dc_fast_count')
        if fast is not None and fast.text:
            fast_charges.add(fast.text)
    
    return jsonify({
        'ciudades': sorted(list(ciudades)),
        'horarios': sorted(list(horarios)),
        'ev_nivel1': sorted(list(ev_nivel1)),
        'ev_nivel2': sorted(list(ev_nivel2)),
        'fast_charges': sorted(list(fast_charges))
    })

if __name__ == '__main__':
    app.run(debug=True)