import 'package:flutter/material.dart';
import 'login_form.dart';
import 'register_form.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6FAFE),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 410),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            child: Column(
              children: [
                const SizedBox(height: 24),
                Container(
                  width: 86,
                  height: 86,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const LinearGradient(
                      colors: [Color(0xFF09CEA5), Color(0xFF429EFF)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: const Center(
                    child: Icon(Icons.favorite_outline, size: 48, color: Colors.white),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Huellitas',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF323D4F),
                  ),
                ),
                const SizedBox(height: 7),
                const Text(
                  'Fundación de rescate y protección',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF909DAA),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 35),
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8EBF2),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: TabBar(
                    controller: _tabController,
                    indicatorSize: TabBarIndicatorSize.tab,
                    indicator: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(25),
                    ),
                    overlayColor: MaterialStateProperty.all(Colors.transparent), // Previene hover rectangular
                    labelColor: const Color(0xFF323D4F),
                    unselectedLabelColor: const Color(0xFF909DAA),
                    tabs: const [
                      Tab(child: SizedBox(height:44, child: Align(alignment: Alignment.center, child: Text('Iniciar Sesión', style: TextStyle(fontSize: 16))))),
                      Tab(child: SizedBox(height:44, child: Align(alignment: Alignment.center, child: Text('Registrarse', style: TextStyle(fontSize: 16))))),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                const Divider(
                  thickness: 1.2,
                  color: Color(0xFFE8EBF2),
                  height: 5,
                  indent: 1,
                  endIndent: 1,
                ),
                const SizedBox(height: 8),
                SizedBox(
                  height: 380,
                  child: TabBarView(
                    controller: _tabController,
                    children: const [
                      LoginForm(),
                      RegisterForm(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
