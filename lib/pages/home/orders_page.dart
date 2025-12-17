import 'package:flutter/material.dart';
import 'package:shamo/theme.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key});

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  final supabase = Supabase.instance.client;
  List<Map<String, dynamic>> transactions = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchOrders();
  }

  Future<void> _fetchOrders() async {
    try {
      final uid = supabase.auth.currentUser!.id;

      // Fetch transactions and items together
      final List<Map<String, dynamic>> data =
          await supabase
              .from('transactions')
              .select('id, total_price, created_at, transaction_items(*)')
              .eq('user_id', uid)
              .order('created_at', ascending: false);

      if (!mounted) return;

      setState(() {
        transactions = data;
        isLoading = false;
      });
    } catch (e) {
      debugPrint('Error fetching orders: $e');
      if (!mounted) return;
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bg3Color,
      appBar: AppBar(
        backgroundColor: bg1Color,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: primaryColor),
        title: Text('Your Orders', style: primaryTextStyle.copyWith(fontWeight: semiBold)),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : transactions.isEmpty
              ? Center(
                  child: Text('No orders yet', style: secondaryTextStyle),
                )
              : ListView.builder(
                  padding: EdgeInsets.all(defaultMargin),
                  itemCount: transactions.length,
                  itemBuilder: (context, index) {
                    final transaction = transactions[index];
                    final items = transaction['transaction_items'] as List<dynamic>? ?? [];

                    return Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: bg2Color,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Order #${transaction['id']}',
                            style: primaryTextStyle.copyWith(fontWeight: semiBold),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Total: \$${transaction['total_price'].toStringAsFixed(2)}',
                            style: secondaryTextStyle,
                          ),
                          const SizedBox(height: 8),
                          ...items.map((item) => Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(item['product_name'], style: primaryTextStyle),
                                  Text('x${item['quantity']}', style: primaryTextStyle),
                                ],
                              )),
                        ],
                      ),
                    );
                  },
                ),
    );
  }
}