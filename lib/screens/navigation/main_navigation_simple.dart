import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../home/home_screen.dart';

class MainNavigation extends StatefulWidget {
  final Widget child;
  
  const MainNavigation({
    super.key,
    required this.child,
  });

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    const EventsScreen(),
    const TicketsScreen(),
    const ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: SafeArea(
          child: Container(
            height: 70,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(
                  context,
                  icon: Icons.home_outlined,
                  selectedIcon: Icons.home,
                  label: 'Inicio',
                  index: 0,
                ),
                _buildNavItem(
                  context,
                  icon: Icons.event_outlined,
                  selectedIcon: Icons.event,
                  label: 'Eventos',
                  index: 1,
                ),
                _buildNavItem(
                  context,
                  icon: Icons.confirmation_number_outlined,
                  selectedIcon: Icons.confirmation_number,
                  label: 'Tickets',
                  index: 2,
                ),
                _buildNavItem(
                  context,
                  icon: Icons.person_outline,
                  selectedIcon: Icons.person,
                  label: 'Perfil',
                  index: 3,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(
    BuildContext context, {
    required IconData icon,
    required IconData selectedIcon,
    required String label,
    required int index,
  }) {
    final isSelected = _currentIndex == index;
    final color = isSelected ? AppTheme.primaryColor : Colors.grey;

    return GestureDetector(
      onTap: () => _onItemTapped(index),
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primaryColor.withOpacity(0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isSelected ? selectedIcon : icon,
              color: color,
              size: 24,
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 10,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                fontFamily: AppTheme.fontFamily,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Pantallas placeholder para navegación
class EventsScreen extends StatelessWidget {
  const EventsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Eventos'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // TODO: Implementar búsqueda
            },
          ),
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              // TODO: Implementar filtros
            },
          ),
        ],
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.event,
              size: 64,
              color: AppTheme.primaryColor,
            ),
            SizedBox(height: 16),
            Text(
              'Eventos',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppTheme.primaryColor,
                fontFamily: AppTheme.fontFamily,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Aquí verás todos los eventos disponibles',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
                fontFamily: AppTheme.fontFamily,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Implementar creación de evento
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class TicketsScreen extends StatelessWidget {
  const TicketsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis Tickets'),
        actions: [
          IconButton(
            icon: const Icon(Icons.qr_code_scanner),
            onPressed: () {
              // TODO: Implementar escáner QR
            },
          ),
        ],
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.confirmation_number,
              size: 64,
              color: AppTheme.primaryColor,
            ),
            SizedBox(height: 16),
            Text(
              'Mis Tickets',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppTheme.primaryColor,
                fontFamily: AppTheme.fontFamily,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Aquí verás todos tus tickets',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
                fontFamily: AppTheme.fontFamily,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // TODO: Implementar configuración
            },
          ),
        ],
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 50,
              backgroundColor: AppTheme.primaryColor,
              child: Icon(
                Icons.person,
                size: 50,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Mi Perfil',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppTheme.primaryColor,
                fontFamily: AppTheme.fontFamily,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Administra tu cuenta y configuración',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
                fontFamily: AppTheme.fontFamily,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
