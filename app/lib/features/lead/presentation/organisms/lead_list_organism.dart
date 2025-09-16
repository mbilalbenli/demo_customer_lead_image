import 'package:flutter/material.dart';
import '../../domain/entities/lead_entity.dart';

class LeadListOrganism extends StatelessWidget {
  final List<LeadEntity> leads;
  final Function(LeadEntity) onLeadTap;
  final VoidCallback? onLoadMore;
  final bool isLoadingMore;

  const LeadListOrganism({
    super.key,
    required this.leads,
    required this.onLeadTap,
    this.onLoadMore,
    this.isLoadingMore = false,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: leads.length + (onLoadMore != null ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == leads.length && onLoadMore != null) {
          if (isLoadingMore) {
            return const Padding(
              padding: EdgeInsets.all(16.0),
              child: Center(child: CircularProgressIndicator()),
            );
          }
          // Load more trigger
          WidgetsBinding.instance.addPostFrameCallback((_) {
            onLoadMore?.call();
          });
          return const SizedBox.shrink();
        }

        final lead = leads[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Theme.of(context).colorScheme.primary,
              child: Text(
                lead.customerName.value.substring(0, 1).toUpperCase(),
                style: const TextStyle(color: Colors.white),
              ),
            ),
            title: Text(
              lead.customerName.value,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(lead.email.value),
                Text(lead.phone.value),
              ],
            ),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () => onLeadTap(lead),
          ),
        );
      },
    );
  }
}