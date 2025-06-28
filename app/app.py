from flask import Flask, Response, render_template, request
import requests
from lxml import etree

app = Flask(__name__)

@app.route('/')
def home():
    # Obtener XML desde la URL
    url = 'https://data.ct.gov/api/views/jfhb-ebu6/rows.xml?accessType=DOWNLOAD'
    response = requests.get(url)
    xml_data = etree.fromstring(response.content)

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
    ciudad = request.args.get('ciudad', '').lower()

    url = 'https://data.ct.gov/api/views/jfhb-ebu6/rows.xml?accessType=DOWNLOAD'
    response = requests.get(url)
    xml_data = etree.fromstring(response.content)

    # Filtrar por ciudad (insensible a mayúsculas)
    filas_filtradas = xml_data.xpath(
        '//row/row[contains(translate(city, "ABCDEFGHIJKLMNOPQRSTUVWXYZ", "abcdefghijklmnopqrstuvwxyz"), "%s")]' % ciudad
    )

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

if __name__ == '__main__':
    app.run(debug=True)