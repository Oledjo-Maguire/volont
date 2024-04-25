import 'package:flutter/material.dart';
import 'CreateEventScreen.dart';
import 'Event.dart';
import 'Register.dart';

class AdminPage extends StatefulWidget {
  final String firstName;
  final String lastName;
  final String middleName;

  AdminPage({Key? key, required this.firstName, required this.lastName, required this.middleName}) : super(key: key);

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> with SingleTickerProviderStateMixin {
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
      body: TabBarView(
        controller: _tabController,
        children: [
          EventPage(
            firstName: widget.firstName,
            lastName: widget.lastName,
            middleName: widget.middleName,
          ),
          const CreateScreen(),
        ],
      ),
      bottomNavigationBar: TabBar(
        labelColor: Colors.black,
        indicatorColor: Colors.black,
        controller: _tabController,
        tabs: const [
          Tab(icon: Text('События')),
          Tab(icon: Text('Добавить события')),
        ],
      ),
    );
  }
}