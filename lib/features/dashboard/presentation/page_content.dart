// lib/features/dashboard/presentation

// abstract class that acts as a contract for all pages
// that can be displayed with in dashboard layout
import 'package:flutter/material.dart';

abstract class PageContent extends StatelessWidget {
  const PageContent({super.key});

  String get title;
}
