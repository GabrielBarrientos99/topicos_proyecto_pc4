<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:output method="html" indent="yes"/>

  <xsl:template match="/">
    <html>
    <head>
      <meta charset="UTF-8"/>
      <title>Estaciones de Carga</title>
      <style>
        table {
          border-collapse: collapse;
          width: 100%;
          font-family: Arial, sans-serif;
        }
        th, td {
          border: 1px solid #ccc;
          padding: 8px;
          text-align: left;
        }
        tr:nth-child(even) { background-color: #f9f9f9; }
        tr:nth-child(odd) { background-color: #ffffff; }
        th {
          background-color: #4275ff;
          color: white;
        }
        form {
          margin-bottom: 20px;
        }
      </style>
    </head>
    <body>
      <h2>Estaciones de Carga de Vehículos Eléctricos en USA</h2>

      <!-- Formulario de filtro -->
      <form action="/filtrar" method="get">
        <label for="ciudad">Filtrar por ciudad:</label>
        <input type="text" name="ciudad" id="ciudad" placeholder="Ej. Meriden"/>
        <input type="submit" value="Buscar"/>
      </form>

      <!-- Tabla de datos -->
      <table>
        <tr>
          <th>Nombre</th>
          <th>Dirección</th>
          <th>Ciudad</th>
          <th>Horario de acceso</th>
          <th>EV Nivel 2</th>
          <th>Fast Charge</th>
        </tr>
        <xsl:for-each select="//row/row">
          <tr>
            <td><xsl:value-of select="station_name"/></td>
            <td><xsl:value-of select="street_address"/></td>
            <td><xsl:value-of select="city"/></td>
            <td><xsl:value-of select="access_days_time"/></td>
            <td><xsl:value-of select="ev_level2_evse_num"/></td>
            <td><xsl:value-of select="ev_dc_fast_count"/></td>
          </tr>
        </xsl:for-each>
      </table>
    </body>
    </html>
  </xsl:template>

</xsl:stylesheet>
