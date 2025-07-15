import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Event Management'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {
              // TODO: Implementar notificaciones
            },
          ),
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // TODO: Implementar búsqueda
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Saludo y bienvenida
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: AppTheme.primaryGradient,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.primaryColor.withOpacity(0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Hola, Usuario!',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Descubre eventos increíbles cerca de ti',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.white70,
                        ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 32),
            
            // Sección de eventos próximos
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Eventos Próximos',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                TextButton(
                  onPressed: () {
                    // TODO: Navegar a todos los eventos
                  },
                  child: const Text('Ver todos'),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // Lista de eventos próximos
            SizedBox(
              height: 250,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 3, // Placeholder
                itemBuilder: (context, index) {
                  return Container(
                    width: 200,
                    margin: const EdgeInsets.only(right: 16),
                    child: Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Imagen del evento
                          Container(
                            height: 120,
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(12),
                              ),
                            ),
                            child: const Center(
                              child: Icon(
                                Icons.event,
                                size: 40,
                                color: AppTheme.primaryColor,
                              ),
                            ),
                          ),
                          
                          // Información del evento
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Evento ${index + 1}',
                                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                          fontWeight: FontWeight.bold,
                                        ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  
                                  const SizedBox(height: 4),
                                  
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.calendar_today,
                                        size: 14,
                                        color: AppTheme.textLightColor,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        '15 Jul 2024',
                                        style: Theme.of(context).textTheme.bodySmall,
                                      ),
                                    ],
                                  ),
                                  
                                  const SizedBox(height: 2),
                                  
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.location_on,
                                        size: 14,
                                        color: AppTheme.textLightColor,
                                      ),
                                      const SizedBox(width: 4),
                                      Expanded(
                                        child: Text(
                                          'Ciudad, País',
                                          style: Theme.of(context).textTheme.bodySmall,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                  
                                  const Spacer(),
                                  
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Gratis',
                                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                              color: AppTheme.successColor,
                                              fontWeight: FontWeight.bold,
                                            ),
                                      ),
                                      const Icon(
                                        Icons.favorite_border,
                                        size: 20,
                                        color: AppTheme.textLightColor,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            
            const SizedBox(height: 32),
            
            // Sección de categorías
            Text(
              'Categorías',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            
            const SizedBox(height: 16),
            
            // Grid de categorías
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 2.5,
              children: [
                _buildCategoryCard(
                  context,
                  'Música',
                  Icons.music_note,
                  Colors.purple,
                ),
                _buildCategoryCard(
                  context,
                  'Deportes',
                  Icons.sports_soccer,
                  Colors.green,
                ),
                _buildCategoryCard(
                  context,
                  'Tecnología',
                  Icons.computer,
                  Colors.blue,
                ),
                _buildCategoryCard(
                  context,
                  'Arte',
                  Icons.palette,
                  Colors.orange,
                ),
              ],
            ),
            
            const SizedBox(height: 32),
            
            // Acciones rápidas
            Text(
              'Acciones Rápidas',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            
            const SizedBox(height: 16),
            
            Row(
              children: [
                Expanded(
                  child: _buildActionCard(
                    context,
                    'Crear Evento',
                    Icons.add_circle_outline,
                    AppTheme.primaryColor,
                    () {
                      // TODO: Navegar a crear evento
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildActionCard(
                    context,
                    'Mis Tickets',
                    Icons.confirmation_number_outlined,
                    AppTheme.secondaryColor,
                    () {
                      // TODO: Navegar a mis tickets
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryCard(
    BuildContext context,
    String title,
    IconData icon,
    Color color,
  ) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () {
          // TODO: Navegar a eventos por categoría
        },
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionCard(
    BuildContext context,
    String title,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 32,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
