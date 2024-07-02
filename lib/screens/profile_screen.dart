import 'package:car_find/provider/theme_provider.dart';
import 'package:car_find/services/profile_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:car_find/models/profile.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: StreamBuilder(
        stream: ProfileService.getUserProfile(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return const Center(
                child: CircularProgressIndicator(),
              );
            default:
              if (!snapshot.hasData) {
                return const Text('User not found');
              }
              Profile profile = snapshot.data!;
              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 50),
                        const Icon(
                          Icons.person,
                          size: 72,
                        ),
                        const SizedBox(height: 24.0),
                        //
                        ListTile(
                          title: const Text('Name'),
                          subtitle: profile.username.isNotEmpty
                              ? Text(profile.username)
                              : const Text('...'),
                          onTap: () {},
                        ),
                        ListTile(
                          title: const Text('Email'),
                          subtitle: profile.email!.isNotEmpty
                              ? Text(profile.email!)
                              : const Text('...'),
                          onTap: () {},
                        ),
                        
                        const SizedBox(height: 24.0),
                        //
                        Consumer<ThemeNotifier>(
                          builder: (context, notifier, child) =>
                              SwitchListTile.adaptive(
                            title: const Text('Dark Mode'),
                            onChanged: (val) {
                              notifier.toggleChangeTheme(val);
                            },
                            value: notifier.darkMode!,
                          ),
                        )
                      ]),
                ),
              );
          }
        },
      ),
    );
  }
}
