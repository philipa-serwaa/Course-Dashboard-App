import 'package:flutter/material.dart';
import 'dart:async';

void main() {
  runApp(const CourseDashboardApp());
}

class CourseDashboardApp extends StatelessWidget {
  const CourseDashboardApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'StudyBloom',
      theme: _buildTheme(Brightness.light),
      darkTheme: _buildTheme(Brightness.dark),
      themeMode: ThemeMode.system,
      home: const DashboardScreen(),
    );
  }
}

ThemeData _buildTheme(Brightness brightness) {
  final base = ThemeData(
    brightness: brightness,
    colorScheme: ColorScheme.fromSeed(
      seedColor: Color(0xFF6C5CE7),
      brightness: brightness,
    ),
    useMaterial3: true,
  );
  final cs = base.colorScheme;

  return base.copyWith(
    scaffoldBackgroundColor: cs.surface,
    appBarTheme: AppBarTheme(
      backgroundColor: cs.surface,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: TextStyle(
        color: cs.onSurface,
        fontSize: 20,
        fontWeight: FontWeight.w700,
      ),
      iconTheme: IconThemeData(color: cs.onSurface),
    ),
    textTheme: base.textTheme.copyWith(
      headlineSmall: TextStyle(fontWeight: FontWeight.w700, color: cs.onSurface),
      titleMedium: TextStyle(fontWeight: FontWeight.w600, color: cs.onSurface),
      bodyMedium: TextStyle(height: 1.4, color: cs.onSurfaceVariant),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: cs.primary,
        foregroundColor: cs.onPrimary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        textStyle: const TextStyle(fontWeight: FontWeight.w600),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: cs.outlineVariant),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      selectedItemColor: cs.primary,
      unselectedItemColor: cs.onSurfaceVariant,
      type: BottomNavigationBarType.fixed,
      showUnselectedLabels: true,
      elevation: 8,
      backgroundColor: cs.surface,
    ),
    dividerTheme: DividerThemeData(
      color: cs.outlineVariant,
      thickness: 0.8,
      space: 0,
    ),
    cardTheme: CardThemeData(
      color: cs.surfaceContainerHighest,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: EdgeInsets.zero,
    ),
  );
}

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _currentIndex = 0;
  bool _enrollExpanded = false;
  String _selectedCategory = 'Science';
  int _featuredIndex = 0;

  final List<Map<String, dynamic>> _courses = const [
    {
      'name': 'Introduction to Biology',
      'instructor': 'Dr. Smith',
      'icon': Icons.biotech,
    },
    {
      'name': 'Fundamentals of Physics',
      'instructor': 'Prof. Johnson',
      'icon': Icons.science,
    },
    {
      'name': 'Modern Art History',
      'instructor': 'Ms. Davis',
      'icon': Icons.brush,
    },
    {
      'name': 'Introduction to Programming',
      'instructor': 'Mr. Lee',
      'icon': Icons.code,
    },
    {
      'name': 'Data Structures',
      'instructor': 'Dr. Garcia',
      'icon': Icons.storage,
    },
    {
      'name': 'Digital Marketing Basics',
      'instructor': 'Ms. Patel',
      'icon': Icons.campaign,
    },
  ];

  final List<String> _categories = const ['Science', 'Arts', 'Technology'];
  final List<Map<String, String>> _featured = const [
    {
      'title': 'Master Data Structures',
      'subtitle': 'Build strong CS foundations',
    },
    {
      'title': 'Creative Modern Art',
      'subtitle': 'History, theory and practice',
    },
    {
      'title': 'Physics by Intuition',
      'subtitle': 'Concepts that stick',
    },
  ];

  Future<void> _showExitDialog() async {
    final shouldExit = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to exit the app?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Yes'),
          ),
        ],
      ),
    );

    if (shouldExit == true) {
      // Navigate to a polished animated logout screen.
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 450),
          pageBuilder: (_, __, ___) => const LoggedOutScreen(),
          transitionsBuilder: (_, animation, __, child) {
            final curved = CurvedAnimation(parent: animation, curve: Curves.easeOutCubic);
            return FadeTransition(
              opacity: curved,
              child: ScaleTransition(scale: Tween<double>(begin: 0.98, end: 1).animate(curved), child: child),
            );
          },
        ),
      );
    }
  }

  Widget _buildActiveTabLabel() {
    const tabNames = ['Home', 'Courses', 'Profile'];
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Row(
        children: [
          Expanded(
            child: Text(
              tabNames[_currentIndex],
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.start,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCoursesGrid() {
    return Expanded(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.maxWidth;
          int crossAxisCount = 1;
          if (width >= 1200) {
            crossAxisCount = 4;
          } else if (width >= 900) {
            crossAxisCount = 3;
          } else if (width >= 600) {
            crossAxisCount = 2;
          }

          if (crossAxisCount == 1) {
            return ListView.separated(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              itemCount: _courses.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final c = _courses[index];
                return CourseCard(
                  title: c['name'] as String,
                  instructor: c['instructor'] as String,
                  iconData: c['icon'] as IconData,
                  onTap: () => _openCourseDetails(
                    title: c['name'] as String,
                    instructor: c['instructor'] as String,
                  ),
                );
              },
            );
          }

          return GridView.builder(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 4 / 2,
            ),
            itemCount: _courses.length,
            itemBuilder: (context, index) {
              final c = _courses[index];
              return CourseCard(
                title: c['name'] as String,
                instructor: c['instructor'] as String,
                iconData: c['icon'] as IconData,
                onTap: () => _openCourseDetails(
                  title: c['name'] as String,
                  instructor: c['instructor'] as String,
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _openCourseDetails({required String title, required String instructor}) {
    Navigator.of(context).push(
      _fadeRoute(CourseDetailsScreen(title: title, instructor: instructor)),
    );
  }

  Widget _buildAnimatedEnrollButton() {
    return Center(
      child: GestureDetector(
        onTapDown: (_) => setState(() => _enrollExpanded = true),
        onTapUp: (_) => setState(() => _enrollExpanded = false),
        onTapCancel: () => setState(() => _enrollExpanded = false),
        child: AnimatedScale(
          duration: const Duration(milliseconds: 160),
          curve: Curves.easeOutCubic,
          scale: _enrollExpanded ? 1.06 : 1.0,
          child: ElevatedButton.icon(
            onPressed: () {
              Navigator.of(context).push(_fadeRoute(const EnrollScreen()));
            },
            icon: const Icon(Icons.school),
            label: const Text('Enroll in a course'),
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InputDecorator(
          decoration: const InputDecoration(
            labelText: 'Course Category',
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _selectedCategory,
              isExpanded: true,
              items: _categories
                  .map(
                    (c) => DropdownMenuItem<String>(
                      value: c,
                      child: Text(c),
                    ),
                  )
                  .toList(),
              onChanged: (val) {
                if (val == null) return;
                setState(() => _selectedCategory = val);
              },
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Selected category: $_selectedCategory',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    );
  }

  Widget _buildBody() {
    switch (_currentIndex) {
      case 0: // Home
        return ListView(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
          children: [
            _buildActiveTabLabel(),
            _FeaturedCarousel(
              items: _featured,
              index: _featuredIndex,
              onChanged: (i) => setState(() => _featuredIndex = i),
            ),
            const SizedBox(height: 16),
            _HomeQuickActions(
              onExplore: () => setState(() => _currentIndex = 1),
              onMyCourses: () => setState(() => _currentIndex = 1),
              onContinue: () => setState(() => _currentIndex = 1),
            ),
            const SizedBox(height: 16),
            _buildCategoryDropdown(),
            const SizedBox(height: 16),
            Text('Recommended for you', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            _AutoScrollingRecommendations(
              courses: _courses,
              onOpen: (title, instructor) => _openCourseDetails(title: title, instructor: instructor),
            ),
            const SizedBox(height: 16),
            _buildAnimatedEnrollButton(),
          ],
        );
      case 1: // Courses
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildActiveTabLabel(),
            _buildCoursesGrid(),
          ],
        );
      case 2: // Profile
        return ListView(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
          children: [
            _buildActiveTabLabel(),
            _ProfileHeader(name: 'Philipa', email: 'philipa@example.com', onEdit: () {
              Navigator.of(context).push(_fadeRoute(const ProfileEditPage()));
            }),
            const SizedBox(height: 16),
            _ProfileQuickStats(colorScheme: Theme.of(context).colorScheme),
            const SizedBox(height: 16),
            _ProfileSettingsList(
              colorScheme: Theme.of(context).colorScheme,
              onOpen: (route) {
                switch (route) {
                  case 'notifications':
                    Navigator.of(context).push(_fadeRoute(const NotificationsPage()));
                    break;
                  case 'privacy':
                    Navigator.of(context).push(_fadeRoute(const PrivacyPage()));
                    break;
                  case 'appearance':
                    Navigator.of(context).push(_fadeRoute(const AppearancePage()));
                    break;
                  case 'help':
                    Navigator.of(context).push(_fadeRoute(const HelpPage()));
                    break;
                }
              },
            ),
          ],
        );
      default:
        return const SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        await _showExitDialog();
      },
      child: Scaffold(
        appBar: AppBar(
        title: const Text('StudyBloom'),
        actions: [
          IconButton(
            tooltip: 'Logout',
            onPressed: _showExitDialog,
            icon: const Icon(Icons.logout),
          ),
        ],
        ),
        body: _buildBody(),
        bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu_book_outlined),
            activeIcon: Icon(Icons.menu_book),
            label: 'Courses',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        ),
      ),
    );
  }
}

class CourseCard extends StatelessWidget {
  const CourseCard({
    super.key,
    required this.title,
    required this.instructor,
    required this.iconData,
    this.onTap,
  });

  final String title;
  final String instructor;
  final IconData iconData;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: cs.primaryContainer,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(iconData, color: cs.onPrimaryContainer),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Instructor: $instructor',
                    style: Theme.of(context).textTheme.bodyMedium,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Icon(Icons.arrow_forward_ios, size: 16, color: cs.onSurfaceVariant),
          ],
        ),
      ),
      ),
    );
  }
}

class CourseMiniCard extends StatelessWidget {
  const CourseMiniCard({
    super.key,
    required this.title,
    required this.instructor,
    required this.iconData,
    this.onTap,
  });

  final String title;
  final String instructor;
  final IconData iconData;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: cs.primaryContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(iconData, color: cs.onPrimaryContainer),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleMedium,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'By $instructor',
                      style: Theme.of(context).textTheme.bodyMedium,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Icon(Icons.arrow_forward_ios, size: 14, color: cs.onSurfaceVariant),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader({
    required this.name,
    required this.email,
    required this.onEdit,
  });

  final String name;
  final String email;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [cs.primary, cs.tertiary],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Center(
                child: Text(
                  name.isNotEmpty ? name[0].toUpperCase() : '?',
                  style: TextStyle(
                    color: cs.onPrimary,
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    email,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
            FilledButton.tonal(
              onPressed: onEdit,
              child: const Text('Edit'),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileQuickStats extends StatelessWidget {
  const _ProfileQuickStats({required this.colorScheme});

  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    Widget stat(String label, String value, IconData icon) {
      return Expanded(
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(icon, color: colorScheme.onPrimaryContainer),
                    ),
                    const Spacer(),
                    Text(
                      value,
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(label, style: Theme.of(context).textTheme.bodyMedium),
              ],
            ),
          ),
        ),
      );
    }

    return Row(
      children: [
        stat('Enrolled', '8', Icons.school),
        const SizedBox(width: 12),
        stat('Completed', '3', Icons.verified),
        const SizedBox(width: 12),
        stat('In Progress', '5', Icons.timelapse),
      ],
    );
  }
}

class _ProfileSettingsList extends StatelessWidget {
  const _ProfileSettingsList({required this.colorScheme, required this.onOpen});

  final ColorScheme colorScheme;
  final void Function(String route) onOpen;

  @override
  Widget build(BuildContext context) {
    List<Widget> tiles = [
      _SettingsTile(icon: Icons.notifications, title: 'Notifications', subtitle: 'Assignments, deadlines, general alerts', route: 'notifications', onOpen: onOpen),
      _SettingsTile(icon: Icons.lock, title: 'Privacy', subtitle: 'Manage data and permissions', route: 'privacy', onOpen: onOpen),
      _SettingsTile(icon: Icons.palette, title: 'Appearance', subtitle: 'Theme and display preferences', route: 'appearance', onOpen: onOpen),
      _SettingsTile(icon: Icons.help, title: 'Help & Support', subtitle: 'FAQs and contact', route: 'help', onOpen: onOpen),
    ];

    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(children: tiles),
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  const _SettingsTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.route,
    required this.onOpen,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final String route;
  final void Function(String route) onOpen;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return ListTile(
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: cs.secondaryContainer,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: cs.onSecondaryContainer),
      ),
      title: Text(title, style: Theme.of(context).textTheme.titleMedium),
      subtitle: Text(subtitle, style: Theme.of(context).textTheme.bodyMedium),
      trailing: const Icon(Icons.chevron_right),
      onTap: () => onOpen(route),
    );
  }
}

class LoggedOutScreen extends StatefulWidget {
  const LoggedOutScreen({super.key});

  @override
  State<LoggedOutScreen> createState() => _LoggedOutScreenState();
}

// Routing helper
PageRouteBuilder<T> _fadeRoute<T>(Widget page) {
  return PageRouteBuilder<T>(
    transitionDuration: const Duration(milliseconds: 320),
    pageBuilder: (_, __, ___) => page,
    transitionsBuilder: (_, animation, __, child) {
      final curved = CurvedAnimation(parent: animation, curve: Curves.easeOutCubic);
      return FadeTransition(opacity: curved, child: child);
    },
  );
}

// Pages
class CourseDetailsScreen extends StatelessWidget {
  const CourseDetailsScreen({super.key, required this.title, required this.instructor});

  final String title;
  final String instructor;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(title: const Text('Course Details')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [cs.primary, cs.tertiary]),
              borderRadius: BorderRadius.circular(16),
            ),
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: cs.onPrimary)),
                const SizedBox(height: 8),
                Text('Instructor: $instructor', style: Theme.of(context).textTheme.titleMedium?.copyWith(color: cs.onPrimary))
              ],
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text('About this course', style: TextStyle(fontWeight: FontWeight.w700)),
                  SizedBox(height: 8),
                  Text('Dive deep with structured modules, hands-on projects, and assessments.'),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          FilledButton.icon(
            onPressed: () => Navigator.of(context).push(_fadeRoute(const EnrollScreen())),
            icon: const Icon(Icons.playlist_add),
            label: const Text('Enroll Now'),
          ),
        ],
      ),
    );
  }
}

class EnrollScreen extends StatelessWidget {
  const EnrollScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Enroll')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.school, size: 64),
              const SizedBox(height: 12),
              Text('Choose your course and confirm enrollment', style: Theme.of(context).textTheme.titleMedium, textAlign: TextAlign.center),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: () => showDialog(
                  context: context,
                  builder: (_) => const AlertDialog(
                    title: Text('Enrollment Confirmed'),
                    content: Text('You are now enrolled. Happy learning!'),
                  ),
                ),
                child: const Text('Confirm Enrollment'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Notifications')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          ListTile(title: Text('Assignment due tomorrow'), subtitle: Text('Data Structures - Lab 2')),
          ListTile(title: Text('New course available'), subtitle: Text('Physics by Intuition')),
        ],
      ),
    );
  }
}

class PrivacyPage extends StatelessWidget {
  const PrivacyPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Privacy')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          ListTile(title: Text('Profile visibility'), subtitle: Text('Only enrolled classmates')),
          ListTile(title: Text('Data usage'), subtitle: Text('Used to personalize recommendations')),
        ],
      ),
    );
  }
}

class AppearancePage extends StatelessWidget {
  const AppearancePage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Appearance')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          ListTile(title: Text('Theme'), subtitle: Text('Follows system')),
          ListTile(title: Text('Typography'), subtitle: Text('Clean and readable')),
        ],
      ),
    );
  }
}

class HelpPage extends StatelessWidget {
  const HelpPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Help & Support')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          ListTile(title: Text('FAQ'), subtitle: Text('Common questions and answers')),
          ListTile(title: Text('Contact'), subtitle: Text('support@studybloom.app')),
        ],
      ),
    );
  }
}

class ProfileEditPage extends StatelessWidget {
  const ProfileEditPage({super.key});
  @override
  Widget build(BuildContext context) {
    final nameController = TextEditingController(text: 'Philipa');
    final emailController = TextEditingController(text: 'philipa@example.com');
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Profile')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextField(controller: nameController, decoration: const InputDecoration(labelText: 'Name')),
          const SizedBox(height: 12),
          TextField(controller: emailController, decoration: const InputDecoration(labelText: 'Email')),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}

class _FeaturedCarousel extends StatefulWidget {
  const _FeaturedCarousel({required this.items, required this.index, required this.onChanged});
  final List<Map<String, String>> items;
  final int index;
  final ValueChanged<int> onChanged;
  @override
  State<_FeaturedCarousel> createState() => _FeaturedCarouselState();
}

class _FeaturedCarouselState extends State<_FeaturedCarousel> {
  late final PageController _pageController;
  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.9, initialPage: widget.index);
  }
  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Column(
      children: [
        SizedBox(
          height: 140,
          child: PageView.builder(
            controller: _pageController,
            itemCount: widget.items.length,
            onPageChanged: widget.onChanged,
            itemBuilder: (_, i) {
              final it = widget.items[i];
              return Padding(
                padding: const EdgeInsets.only(right: 12.0),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    gradient: LinearGradient(colors: [cs.primary, cs.tertiary]),
                  ),
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(it['title'] ?? '', style: Theme.of(context).textTheme.titleMedium?.copyWith(color: cs.onPrimary)),
                      const SizedBox(height: 6),
                      Text(it['subtitle'] ?? '', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: cs.onPrimary)),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            widget.items.length,
            (i) => Container(
              width: 8,
              height: 8,
              margin: const EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: i == widget.index ? cs.primary : cs.outlineVariant,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _HomeQuickActions extends StatelessWidget {
  const _HomeQuickActions({required this.onExplore, required this.onMyCourses, required this.onContinue});
  final VoidCallback onExplore;
  final VoidCallback onMyCourses;
  final VoidCallback onContinue;
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    Widget action(IconData icon, String label, VoidCallback onTap) {
      return Expanded(
        child: Card(
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
              child: Column(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: cs.secondaryContainer,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(icon, color: cs.onSecondaryContainer),
                  ),
                  const SizedBox(height: 8),
                  Text(label, style: Theme.of(context).textTheme.titleMedium, textAlign: TextAlign.center),
                ],
              ),
            ),
          ),
        ),
      );
    }

    return Row(
      children: [
        action(Icons.explore, 'Explore', onExplore),
        const SizedBox(width: 12),
        action(Icons.menu_book, 'My Courses', onMyCourses),
        const SizedBox(width: 12),
        action(Icons.play_circle, 'Continue', onContinue),
      ],
    );
  }
}

class _AutoScrollingRecommendations extends StatefulWidget {
  const _AutoScrollingRecommendations({
    required this.courses,
    required this.onOpen,
  });

  final List<Map<String, dynamic>> courses;
  final void Function(String title, String instructor) onOpen;

  @override
  State<_AutoScrollingRecommendations> createState() => _AutoScrollingRecommendationsState();
}

class _AutoScrollingRecommendationsState extends State<_AutoScrollingRecommendations> {
  final PageController _controller = PageController(viewportFraction: 0.75);
  Timer? _timer;
  int _current = 0;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 5), (_) {
      if (!mounted) return;
      final next = (_current + 1) % widget.courses.length;
      _controller.animateToPage(
        next,
        duration: const Duration(milliseconds: 450),
        curve: Curves.easeOutCubic,
      );
      setState(() => _current = next);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 140,
      child: PageView.builder(
        controller: _controller,
        itemCount: widget.courses.length,
        onPageChanged: (i) => setState(() => _current = i),
        itemBuilder: (context, index) {
          final c = widget.courses[index];
          return AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              double scale = 1.0;
              if (_controller.position.haveDimensions) {
                final double page = (_controller.page ?? _controller.initialPage.toDouble());
                final double delta = page - index.toDouble();
                scale = 1 - (delta.abs() * 0.2);
                scale = scale.clamp(0.9, 1.0);
              }
              return Transform.scale(
                scale: scale,
                child: Padding(
                  padding: const EdgeInsets.only(right: 12.0),
                  child: CourseMiniCard(
                    title: c['name'] as String,
                    instructor: c['instructor'] as String,
                    iconData: c['icon'] as IconData,
                    onTap: () => widget.onOpen(c['name'] as String, c['instructor'] as String),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class _LoggedOutScreenState extends State<LoggedOutScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _pulse;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
    _pulse = Tween<double>(begin: 0.96, end: 1.04)
        .chain(CurveTween(curve: Curves.easeInOut))
        .animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(title: const Text('StudyBloom')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ScaleTransition(
                scale: _pulse,
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [cs.primary, cs.tertiary],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Icon(Icons.logout, size: 64, color: cs.onPrimary),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'You have logged out of StudyBloom',
                style: Theme.of(context).textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'Thanks for learning with us. See you soon!',
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              FilledButton(
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                    PageRouteBuilder(
                      transitionDuration: const Duration(milliseconds: 400),
                      pageBuilder: (_, __, ___) => const DashboardScreen(),
                      transitionsBuilder: (_, animation, __, child) {
                        final curved = CurvedAnimation(parent: animation, curve: Curves.easeOutCubic);
                        return FadeTransition(opacity: curved, child: child);
                      },
                    ),
                  );
                },
                child: const Text('Back to Dashboard'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


