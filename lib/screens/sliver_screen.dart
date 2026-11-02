import 'package:flutter/material.dart';

// Dimensions helper matching your tutorial
class Dimens {
  static const double largePadding = 16.0;
  static const double padding = 8.0;
  static const double corners = 16.0;
}

class SliverScreen extends StatelessWidget {
  const SliverScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            toolbarHeight: 80,
            backgroundColor: Colors.white,
            elevation: 0,
            floating: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Padding(
                padding: const EdgeInsets.all(Dimens.largePadding),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: const [Header()],
                ),
              ),
            ),
          ),
          SliverAppBar(
            expandedHeight: 180,
            pinned: true,
            backgroundColor: Colors.blue,
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsets.only(left: 16, bottom: 16),
              centerTitle: false,
              title: const Text(
                "My Gallery",
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
              background: Image.network(
                'https://images.unsplash.com/photo-1506744038136-46273834b3fb?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1170&q=80',
                fit: BoxFit.cover,
              ),
            ),
          ),
          SliverAppBar(
            backgroundColor: Colors.grey.shade100,
            toolbarHeight: 120,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const Text(
                    'Quick actions',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: Dimens.largePadding,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: const [
                        ActionItem(icon: Icons.call_made, label: "Send"),
                        ActionItem(icon: Icons.call_received, label: "Receive"),
                        ActionItem(icon: Icons.groups, label: "Family"),
                        ActionItem(icon: Icons.more_horiz, label: "More"),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const TransactionsList(),
          SliverFillRemaining(),
        ],
      ),
    );
  }
}

// Header widget from Screenshot 2
class Header extends StatelessWidget {
  const Header({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'Welcome back!',
              style: TextStyle(fontSize: 14, color: Colors.blueGrey),
            ),
            Text(
              'Ales Dev',
              style: TextStyle(
                fontSize: 22,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const AppBorderedIconButton(width: 46, height: 46, color: Colors.black),
      ],
    );
  }
}

// Bordered notification icon button
class AppBorderedIconButton extends StatelessWidget {
  final String? iconPath;
  final IconData icon;
  final double width;
  final double height;
  final Color color;

  const AppBorderedIconButton({
    super.key,
    this.iconPath,
    this.icon = Icons.notifications_outlined,
    this.width = 46,
    this.height = 46,
    this.color = Colors.black,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(child: Icon(icon, color: color, size: 22)),
    );
  }
}

// ActionItem widget for the Quick actions row
class ActionItem extends StatelessWidget {
  final IconData icon;
  final String label;

  const ActionItem({super.key, required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Icon(icon, color: Colors.black87, size: 22),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade700,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

// TransactionsList widget from Screenshots
class TransactionsList extends StatelessWidget {
  const TransactionsList({super.key});

  @override
  Widget build(BuildContext context) {
    final transactions = [
      {"title": "Starbucks Coffee", "date": "Today", "amount": r"-$6.50"},
      {"title": "Netflix", "date": "Yesterday", "amount": r"-$15.99"},
      {"title": "Salary Deposit", "date": "Jan 18", "amount": r"+$2,200.00"},
      {"title": "Uber Ride", "date": "Jan 16", "amount": r"-$12.80"},
      {"title": "Grocery Store", "date": "Jan 14", "amount": r"-$54.20"},
    ];

    return SliverList(
      delegate: SliverChildBuilderDelegate((context, index) {
        final item = transactions[index];
        final isPositive = item["amount"]!.contains("+");

        return Container(
          margin: const EdgeInsets.symmetric(
            horizontal: Dimens.largePadding,
            vertical: Dimens.padding,
          ),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(Dimens.corners),
          ),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.grey.shade300,
              child: const Icon(Icons.wallet, color: Colors.black87),
            ),
            title: Text(
              item["title"]!,
              style: const TextStyle(color: Colors.black, fontSize: 16),
            ),
            subtitle: Text(
              item["date"]!,
              style: const TextStyle(color: Colors.black, fontSize: 12),
            ),
            trailing: Text(
              item["amount"]!,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: isPositive ? Colors.green : Colors.red,
                fontSize: 14,
              ),
            ),
          ),
        );
      }, childCount: transactions.length),
    );
  }
}
