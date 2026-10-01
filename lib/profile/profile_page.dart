import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../database/app_database.dart';
import '../models/profile_model.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _nameController = TextEditingController();
  final _babyNameController = TextEditingController();

  final _auth = FirebaseAuth.instance;

  bool _loading = true;
  bool _saving = false;

  User? get _user => _auth.currentUser;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _babyNameController.dispose();
    super.dispose();
  }

  Future<void> _loadProfile() async {
    final user = _user;

    if (user == null) {
      return;
    }

    final profile = await AppDatabase.instance.getProfile(
      user.uid,
    );

    if (!mounted) return;

    if (profile != null) {
      _nameController.text = profile.name;
      _babyNameController.text = profile.babyName ?? '';
    }

    setState(() {
      _loading = false;
    });
  }

  Future<void> _saveProfile() async {
    final user = _user;

    if (user == null) return;

    final name = _nameController.text.trim();
    final babyName = _babyNameController.text.trim();

    if (name.isEmpty) {
      _showMessage('Please enter your name.');
      return;
    }

    setState(() {
      _saving = true;
    });

    try {
      final existingProfile =
          await AppDatabase.instance.getProfile(user.uid);

      final now = DateTime.now();

      final profile = Profile(
        firebaseUid: user.uid,
        name: name,
        email: user.email ?? '',
        babyName: babyName.isEmpty ? null : babyName,
        createdAt: existingProfile?.createdAt ?? now,
        updatedAt: now,
      );

      await AppDatabase.instance.saveProfile(profile);

      if (!mounted) return;

      _showMessage('Profile saved.');
    } finally {
      if (mounted) {
        setState(() {
          _saving = false;
        });
      }
    }
  }

  Future<void> _logout() async {
    await _auth.signOut();
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = _user;

    if (_loading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: 500,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const CircleAvatar(
                    radius: 42,
                    child: Icon(
                      Icons.person,
                      size: 42,
                    ),
                  ),

                  const SizedBox(height: 24),

                  Text(
                    user?.email ?? '',
                    textAlign: TextAlign.center,
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge,
                  ),

                  const SizedBox(height: 32),

                  TextField(
                    controller: _nameController,
                    textCapitalization:
                        TextCapitalization.words,
                    decoration: const InputDecoration(
                      labelText: 'Your name',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(
                        Icons.person_outline,
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  TextField(
                    controller: _babyNameController,
                    textCapitalization:
                        TextCapitalization.words,
                    decoration: const InputDecoration(
                      labelText: "Baby's name (optional)",
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(
                        Icons.child_care,
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  SizedBox(
                    height: 52,
                    child: FilledButton(
                      onPressed: _saving
                          ? null
                          : _saveProfile,
                      child: _saving
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child:
                                  CircularProgressIndicator(
                                strokeWidth: 2,
                              ),
                            )
                          : const Text('Save profile'),
                    ),
                  ),

                  const SizedBox(height: 32),

                  const Divider(),

                  const SizedBox(height: 16),

                  OutlinedButton.icon(
                    onPressed: _logout,
                    icon: const Icon(Icons.logout),
                    label: const Text('Log out'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}