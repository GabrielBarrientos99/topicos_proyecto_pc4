<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:output method="html" indent="yes"/>

  <xsl:template match="/">
    <html>
    <head>
      <meta charset="UTF-8"/>
      <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
      <title>🔋 Estaciones de Carga EV - Connecticut</title>
      <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet"/>
      <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&amp;display=swap" rel="stylesheet"/>
      <style>
        * {
          margin: 0;
          padding: 0;
          box-sizing: border-box;
        }

        body {
          font-family: 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif;
          background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
          min-height: 100vh;
          color: #333;
        }

        .container {
          max-width: 1400px;
          margin: 0 auto;
          padding: 20px;
        }

        .header {
          text-align: center;
          margin-bottom: 40px;
          color: white;
        }

        .header h1 {
          font-size: 3rem;
          font-weight: 700;
          margin-bottom: 10px;
          text-shadow: 0 4px 8px rgba(0,0,0,0.3);
        }

        .header p {
          font-size: 1.2rem;
          opacity: 0.9;
          font-weight: 300;
        }

        .filters-card {
          background: rgba(255, 255, 255, 0.95);
          backdrop-filter: blur(20px);
          border-radius: 24px;
          padding: 30px;
          margin-bottom: 30px;
          box-shadow: 0 20px 40px rgba(0,0,0,0.1);
          border: 1px solid rgba(255,255,255,0.2);
        }

        .filters-title {
          display: flex;
          align-items: center;
          gap: 12px;
          margin-bottom: 25px;
          font-size: 1.5rem;
          font-weight: 600;
          color: #4c51bf;
        }

        .filters-grid {
          display: grid;
          grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
          gap: 20px;
          margin-bottom: 25px;
        }

        .filter-group {
          position: relative;
        }

        .filter-label {
          display: block;
          margin-bottom: 8px;
          font-weight: 500;
          color: #374151;
          font-size: 0.9rem;
        }

        .filter-input, .filter-select {
          width: 100%;
          padding: 12px 16px;
          border: 2px solid #e5e7eb;
          border-radius: 12px;
          font-size: 1rem;
          transition: all 0.3s ease;
          background: white;
          font-family: inherit;
        }

        .filter-input:focus, .filter-select:focus {
          outline: none;
          border-color: #667eea;
          box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
          transform: translateY(-1px);
        }

        .filter-input::placeholder {
          color: #9ca3af;
        }

        .search-icon {
          position: absolute;
          right: 12px;
          top: 50%;
          transform: translateY(-50%);
          color: #9ca3af;
          pointer-events: none;
        }

        .filter-actions {
          display: flex;
          gap: 15px;
          justify-content: center;
          flex-wrap: wrap;
        }

        .btn {
          padding: 12px 24px;
          border: none;
          border-radius: 12px;
          font-size: 1rem;
          font-weight: 500;
          cursor: pointer;
          transition: all 0.3s ease;
          display: flex;
          align-items: center;
          gap: 8px;
          font-family: inherit;
        }

        .btn-primary {
          background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
          color: white;
          box-shadow: 0 4px 15px rgba(102, 126, 234, 0.4);
        }

        .btn-primary:hover {
          transform: translateY(-2px);
          box-shadow: 0 8px 25px rgba(102, 126, 234, 0.6);
        }

        .btn-secondary {
          background: #f3f4f6;
          color: #374151;
          border: 2px solid #e5e7eb;
        }

        .btn-secondary:hover {
          background: #e5e7eb;
          transform: translateY(-1px);
        }

        .results-card {
          background: rgba(255, 255, 255, 0.95);
          backdrop-filter: blur(20px);
          border-radius: 24px;
          overflow: hidden;
          box-shadow: 0 20px 40px rgba(0,0,0,0.1);
          border: 1px solid rgba(255,255,255,0.2);
        }

        .results-header {
          padding: 25px 30px;
          background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
          color: white;
          display: flex;
          align-items: center;
          justify-content: space-between;
        }

        .results-title {
          font-size: 1.3rem;
          font-weight: 600;
          display: flex;
          align-items: center;
          gap: 10px;
        }

        .results-count {
          background: rgba(255,255,255,0.2);
          padding: 6px 12px;
          border-radius: 20px;
          font-size: 0.9rem;
          font-weight: 500;
        }

        .table-container {
          overflow-x: auto;
          max-height: 70vh;
        }

        table {
          width: 100%;
          border-collapse: collapse;
          font-size: 0.95rem;
          table-layout: fixed;
          min-width: 800px;
        }

        th {
          background: #f8fafc;
          color: #374151;
          font-weight: 600;
          padding: 18px 20px;
          text-align: left;
          border-bottom: 2px solid #e5e7eb;
          position: sticky;
          top: 0;
          z-index: 10;
          white-space: nowrap;
          overflow: hidden;
          text-overflow: ellipsis;
        }

        th:nth-child(1) { width: 20%; }  /* Nombre */
        th:nth-child(2) { width: 25%; }  /* Dirección */
        th:nth-child(3) { width: 15%; }  /* Ciudad */
        th:nth-child(4) { width: 20%; }  /* Horario */
        th:nth-child(5) { width: 7%; }   /* EV Nivel 1 */
        th:nth-child(6) { width: 7%; }   /* EV Nivel 2 */
        th:nth-child(7) { width: 6%; }   /* Carga Rápida */

        td {
          padding: 16px 20px;
          border-bottom: 1px solid #f1f5f9;
          vertical-align: top;
          white-space: nowrap;
          overflow: hidden;
          text-overflow: ellipsis;
        }

        td:nth-child(1) { width: 20%; white-space: normal; }  /* Nombre */
        td:nth-child(2) { width: 25%; white-space: normal; }  /* Dirección */
        td:nth-child(3) { width: 15%; }  /* Ciudad */
        td:nth-child(4) { width: 20%; white-space: normal; }  /* Horario */
        td:nth-child(5) { width: 7%; text-align: center; }   /* EV Nivel 1 */
        td:nth-child(6) { width: 7%; text-align: center; }   /* EV Nivel 2 */
        td:nth-child(7) { width: 6%; text-align: center; }   /* Carga Rápida */

        tr:hover {
          background: #f8fafc;
          transform: scale(1.001);
          transition: all 0.2s ease;
        }

        /* Zebra stripes for better readability */
        tbody tr:nth-child(even) {
          background: #fafafa;
        }

        /* Sortable table headers */
        th.sortable {
          cursor: pointer;
          user-select: none;
        }
        th.sortable i {
          margin-left: 6px;
          opacity: 0.6;
          transition: transform 0.3s ease;
        }
        th.sortable.asc i {
          transform: rotate(180deg);
        }

        .station-name {
          font-weight: 600;
          color: #4c51bf;
          display: flex;
          align-items: center;
          gap: 8px;
        }

        .station-name::before {
          content: "⚡";
          font-size: 1.2em;
        }

        .address {
          color: #6b7280;
          display: flex;
          align-items: center;
          gap: 6px;
        }

        .address::before {
          content: "📍";
        }

        .city {
          background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
          color: white;
          padding: 4px 12px;
          border-radius: 20px;
          font-size: 0.85rem;
          font-weight: 500;
          display: inline-block;
        }

        .schedule {
          color: #059669;
          font-weight: 500;
          display: flex;
          align-items: center;
          gap: 6px;
        }

        .schedule::before {
          content: "🕒";
        }

        .ev-info {
          display: flex;
          align-items: center;
          gap: 6px;
          font-weight: 500;
        }

        .ev-level1::before { content: "🔌"; }
        .ev-level2::before { content: "⚡"; }
        .fast-charge::before { content: "⚡"; color: #dc2626; }

        .none-value {
          color: #9ca3af;
          font-style: italic;
        }

        .loading {
          display: none;
          text-align: center;
          padding: 40px;
          color: #6b7280;
        }

        .spinner {
          display: inline-block;
          width: 32px;
          height: 32px;
          border: 3px solid #f3f4f6;
          border-radius: 50%;
          border-top-color: #667eea;
          animation: spin 1s ease-in-out infinite;
          margin-right: 10px;
        }

        @keyframes spin {
          to { transform: rotate(360deg); }
        }

        .no-results {
          text-align: center;
          padding: 60px 20px;
          color: #6b7280;
        }

        .no-results-icon {
          font-size: 4rem;
          margin-bottom: 20px;
          opacity: 0.5;
        }

        @media (max-width: 768px) {
          .container {
            padding: 15px;
          }
          
          .header h1 {
            font-size: 2rem;
          }
          
          .filters-grid {
            grid-template-columns: 1fr;
          }
          
          .filter-actions {
            flex-direction: column;
          }
          
          .btn {
            justify-content: center;
          }
          
          .results-header {
            flex-direction: column;
            gap: 15px;
            text-align: center;
          }
        }

        .fade-in {
          animation: fadeIn 0.5s ease-in;
        }

        @keyframes fadeIn {
          from { opacity: 0; transform: translateY(20px); }
          to { opacity: 1; transform: translateY(0); }
        }
      </style>
    </head>
    <body>
      <div class="container">
        <!-- Header -->
        <div class="header">
          <h1>🔋 Estaciones de Carga EV</h1>
          <p>Encuentra estaciones de carga para vehículos eléctricos en Connecticut</p>
        </div>

        <!-- Filtros -->
        <div class="filters-card">
          <div class="filters-title">
            <i class="fas fa-filter"></i>
            Filtros Avanzados
          </div>
          
          <div class="filters-grid">
            <!-- Búsqueda por nombre -->
            <div class="filter-group">
              <label class="filter-label" for="nombre">🏢 Nombre de la estación</label>
              <div style="position: relative;">
                <input type="text" id="nombre" class="filter-input" placeholder="Buscar por nombre..." autocomplete="off"/>
                <i class="fas fa-search search-icon"></i>
              </div>
            </div>

            <!-- Búsqueda por dirección -->
            <div class="filter-group">
              <label class="filter-label" for="direccion">📍 Dirección</label>
              <div style="position: relative;">
                <input type="text" id="direccion" class="filter-input" placeholder="Buscar por dirección..." autocomplete="off"/>
                <i class="fas fa-map-marker-alt search-icon"></i>
              </div>
            </div>

            <!-- Filtro por ciudad -->
            <div class="filter-group">
              <label class="filter-label" for="ciudad">🏙️ Ciudad</label>
              <select id="ciudad" class="filter-select">
                <option value="">Todas las ciudades</option>
              </select>
            </div>

            <!-- Filtro por horario -->
            <div class="filter-group">
              <label class="filter-label" for="horario">🕒 Horario de acceso</label>
              <select id="horario" class="filter-select">
                <option value="">Todos los horarios</option>
              </select>
            </div>

            <!-- Filtro EV Nivel 1 -->
            <div class="filter-group">
              <label class="filter-label" for="ev_nivel1">🔌 EV Nivel 1</label>
              <select id="ev_nivel1" class="filter-select">
                <option value="">Cualquier nivel 1</option>
              </select>
            </div>

            <!-- Filtro EV Nivel 2 -->
            <div class="filter-group">
              <label class="filter-label" for="ev_nivel2">⚡ EV Nivel 2</label>
              <select id="ev_nivel2" class="filter-select">
                <option value="">Cualquier nivel 2</option>
              </select>
            </div>

            <!-- Filtro Fast Charge -->
            <div class="filter-group">
              <label class="filter-label" for="fast_charge">⚡ Carga Rápida</label>
              <select id="fast_charge" class="filter-select">
                <option value="">Cualquier carga rápida</option>
              </select>
            </div>
          </div>

          <div class="filter-actions">
            <button type="button" class="btn btn-secondary" onclick="limpiarFiltros()">
              <i class="fas fa-eraser"></i>
              Limpiar Filtros
            </button>
          </div>
        </div>

        <!-- Loading -->
        <div class="loading" id="loading">
          <div class="spinner"></div>
          Cargando resultados...
        </div>

        <!-- Resultados -->
        <div class="results-card" id="results">
          <div class="results-header">
            <div class="results-title">
              <i class="fas fa-table"></i>
              Resultados
            </div>
            <div class="results-count" id="resultsCount">
              <xsl:value-of select="count(//row)"/> estaciones encontradas
            </div>
          </div>

          <div class="table-container">
            <table id="dataTable">
              <thead>
                <tr>
                  <th class="sortable">🏢 Nombre de la Estación <i class="fas fa-sort"></i></th>
                  <th class="sortable">📍 Dirección <i class="fas fa-sort"></i></th>
                  <th class="sortable">🏙️ Ciudad <i class="fas fa-sort"></i></th>
                  <th class="sortable">🕒 Horario de Acceso <i class="fas fa-sort"></i></th>
                  <th class="sortable">🔌 EV Nivel 1 <i class="fas fa-sort"></i></th>
                  <th class="sortable">⚡ EV Nivel 2 <i class="fas fa-sort"></i></th>
                  <th class="sortable">⚡ Carga Rápida <i class="fas fa-sort"></i></th>
                </tr>
              </thead>
              <tbody id="tableBody">
                <xsl:choose>
                  <xsl:when test="count(//row/row) = 0">
                    <tr>
                      <td colspan="7" class="no-results">
                        <div class="no-results-icon">🔍</div>
                        <h3>No se encontraron resultados</h3>
                        <p>Intenta ajustar los filtros para encontrar estaciones.</p>
                      </td>
                    </tr>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:for-each select="//row/row">
                      <tr class="fade-in">
                        <td class="station-name">
                          <xsl:value-of select="station_name"/>
                        </td>
                        <td class="address">
                          <xsl:value-of select="street_address"/>
                        </td>
                        <td>
                          <span class="city">
                            <xsl:value-of select="city"/>
                          </span>
                        </td>
                        <td class="schedule">
                          <xsl:value-of select="access_days_time"/>
                        </td>
                        <td class="ev-info ev-level1">
                          <xsl:choose>
                            <xsl:when test="ev_level1_evse_num = 'NONE'">
                              <span class="none-value">Ninguno</span>
                            </xsl:when>
                            <xsl:otherwise>
                              <xsl:value-of select="ev_level1_evse_num"/>
                            </xsl:otherwise>
                          </xsl:choose>
                        </td>
                        <td class="ev-info ev-level2">
                          <xsl:choose>
                            <xsl:when test="ev_level2_evse_num = 'NONE'">
                              <span class="none-value">Ninguno</span>
                            </xsl:when>
                            <xsl:otherwise>
                              <xsl:value-of select="ev_level2_evse_num"/>
                            </xsl:otherwise>
                          </xsl:choose>
                        </td>
                        <td class="ev-info fast-charge">
                          <xsl:choose>
                            <xsl:when test="ev_dc_fast_count = 'NONE'">
                              <span class="none-value">Ninguno</span>
                            </xsl:when>
                            <xsl:otherwise>
                              <xsl:value-of select="ev_dc_fast_count"/>
                            </xsl:otherwise>
                          </xsl:choose>
                        </td>
                      </tr>
                    </xsl:for-each>
                  </xsl:otherwise>
                </xsl:choose>
              </tbody>
            </table>
          </div>
        </div>
      </div>

      <script><![CDATA[
        let debounceTimer;
        let opcionesCache = null;

        // Cargar opciones para los selects al inicio
        async function cargarOpciones() {
          try {
            const response = await fetch('/api/opciones');
            opcionesCache = await response.json();
            
            // Poblar selects
            poblarSelect('ciudad', opcionesCache.ciudades);
            poblarSelect('horario', opcionesCache.horarios);
            poblarSelect('ev_nivel1', opcionesCache.ev_nivel1);
            poblarSelect('ev_nivel2', opcionesCache.ev_nivel2);
            poblarSelect('fast_charge', opcionesCache.fast_charges);
          } catch (error) {
            console.error('Error cargando opciones:', error);
          }
        }

        function poblarSelect(selectId, opciones) {
          const select = document.getElementById(selectId);
          const valorActual = select.value;
          
          // Limpiar opciones existentes (excepto la primera)
          while (select.children.length > 1) {
            select.removeChild(select.lastChild);
          }
          
          // Agregar nuevas opciones
          opciones.forEach(opcion => {
            const option = document.createElement('option');
            option.value = opcion;
            option.textContent = opcion;
            select.appendChild(option);
          });
          
          // Restaurar valor si existía
          if (valorActual) {
            select.value = valorActual;
          }
        }

        function aplicarFiltros() {
          const loading = document.getElementById('loading');
          const results = document.getElementById('results');
          
          // Mostrar loading
          loading.style.display = 'block';
          results.style.display = 'none';
          
          // Construir URL con parámetros
          const params = new URLSearchParams();
          
          const nombre = document.getElementById('nombre').value.trim();
          const direccion = document.getElementById('direccion').value.trim();
          const ciudad = document.getElementById('ciudad').value;
          const horario = document.getElementById('horario').value;
          const ev_nivel1 = document.getElementById('ev_nivel1').value;
          const ev_nivel2 = document.getElementById('ev_nivel2').value;
          const fast_charge = document.getElementById('fast_charge').value;
          
          if (nombre) params.append('nombre', nombre);
          if (direccion) params.append('direccion', direccion);
          if (ciudad) params.append('ciudad', ciudad);
          if (horario) params.append('horario', horario);
          if (ev_nivel1) params.append('ev_nivel1', ev_nivel1);
          if (ev_nivel2) params.append('ev_nivel2', ev_nivel2);
          if (fast_charge) params.append('fast_charge', fast_charge);
          
          // Hacer petición
          const url = params.toString() ? `/filtrar?${params.toString()}` : '/';
          
          fetch(url)
            .then(response => response.text())
            .then(html => {
              // Crear un documento temporal para extraer solo la tabla
              const tempDiv = document.createElement('div');
              tempDiv.innerHTML = html;
              
              const newTable = tempDiv.querySelector('#dataTable');
              const newCount = tempDiv.querySelector('#resultsCount');
              
              if (newTable) {
                document.getElementById('dataTable').innerHTML = newTable.innerHTML;
              }
              
              if (newCount) {
                document.getElementById('resultsCount').textContent = newCount.textContent;
              }
              
              // Ocultar loading y mostrar resultados
              loading.style.display = 'none';
              results.style.display = 'block';
            })
            .catch(error => {
              console.error('Error:', error);
              loading.style.display = 'none';
              results.style.display = 'block';
            });
        }

        function limpiarFiltros() {
          document.getElementById('nombre').value = '';
          document.getElementById('direccion').value = '';
          document.getElementById('ciudad').value = '';
          document.getElementById('horario').value = '';
          document.getElementById('ev_nivel1').value = '';
          document.getElementById('ev_nivel2').value = '';
          document.getElementById('fast_charge').value = '';
          
          aplicarFiltros();
        }

        function debounceFilter() {
          clearTimeout(debounceTimer);
          debounceTimer = setTimeout(aplicarFiltros, 300);
        }

        /* Tabla: Ordenamiento básico por columna */
        function sortTable(columnIndex) {
          const table = document.getElementById('dataTable');
          const tbody = table.tBodies[0];
          const rows = Array.from(tbody.querySelectorAll('tr'));

          const currentSortCol = table.getAttribute('data-sort-col');
          const currentSortDir = table.getAttribute('data-sort-dir') || 'asc';
          const ascending = !(currentSortCol == columnIndex && currentSortDir === 'asc');

          rows.sort((a, b) => {
            let aText = a.children[columnIndex].innerText.trim().toLowerCase();
            let bText = b.children[columnIndex].innerText.trim().toLowerCase();

            if (!isNaN(aText) && !isNaN(bText)) {
              aText = parseFloat(aText);
              bText = parseFloat(bText);
            }

            if (aText < bText) return ascending ? -1 : 1;
            if (aText > bText) return ascending ? 1 : -1;
            return 0;
          });

          rows.forEach(row => tbody.appendChild(row));

          table.setAttribute('data-sort-col', columnIndex);
          table.setAttribute('data-sort-dir', ascending ? 'asc' : 'desc');

          // Actualizar estado de encabezados
          document.querySelectorAll('#dataTable th').forEach((th, i) => {
            th.classList.remove('asc');
            if (i === columnIndex && ascending) {
              th.classList.add('asc');
            }
          });
        }

        // Event listeners
        document.addEventListener('DOMContentLoaded', function() {
          cargarOpciones();
          
          // Búsqueda en tiempo real para inputs de texto
          document.getElementById('nombre').addEventListener('input', debounceFilter);
          document.getElementById('direccion').addEventListener('input', debounceFilter);
          
          // Filtrado inmediato para selects
          document.getElementById('ciudad').addEventListener('change', aplicarFiltros);
          document.getElementById('horario').addEventListener('change', aplicarFiltros);
          document.getElementById('ev_nivel1').addEventListener('change', aplicarFiltros);
          document.getElementById('ev_nivel2').addEventListener('change', aplicarFiltros);
          document.getElementById('fast_charge').addEventListener('change', aplicarFiltros);

          // Ordenamiento de columnas
          document.querySelectorAll('#dataTable th.sortable').forEach((th, idx) => {
            th.addEventListener('click', () => sortTable(idx));
          });
        });
      ]]></script>
    </body>
    </html>
  </xsl:template>

</xsl:stylesheet>
