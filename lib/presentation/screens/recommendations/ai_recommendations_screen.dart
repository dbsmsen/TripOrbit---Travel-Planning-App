import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AiRecommendationsScreen extends ConsumerStatefulWidget {
  const AiRecommendationsScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<AiRecommendationsScreen> createState() =>
      _AiRecommendationsScreenState();
}

class _AiRecommendationsScreenState extends ConsumerState<AiRecommendationsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<String> _interests = [
    'Adventure',
    'Culture',
    'Food',
    'Nature',
    'Shopping',
    'Relaxation',
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Recommendations'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'For You'),
            Tab(text: 'Trending'),
            Tab(text: 'Nearby'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildForYouTab(),
          _buildTrendingTab(),
          _buildNearbyTab(),
        ],
      ),
    );
  }

  Widget _buildForYouTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInterestSelector(),
          const SizedBox(height: 24),
          const Text(
            'Recommended for You',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          _buildRecommendationList(),
        ],
      ),
    );
  }

  Widget _buildInterestSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Your Interests',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _interests.map((interest) {
            return FilterChip(
              label: Text(interest),
              selected: true,
              onSelected: (bool selected) {
                // TODO: Implement interest selection
              },
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildRecommendationList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 5,
      itemBuilder: (context, index) {
        return _buildRecommendationCard(
          title: 'Kyoto Cultural Experience',
          description: 'Immerse yourself in traditional Japanese culture with tea ceremonies, temple visits, and more.',
          rating: 4.8,
          price: '\$120',
          image: 'assets/images/recommendations/kyoto.jpg',
          tags: ['Culture', 'History', 'Traditional'],
        );
      },
    );
  }

  Widget _buildRecommendationCard({
    required String title,
    required String description,
    required double rating,
    required String price,
    required String image,
    required List<String> tags,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 200,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(12),
              ),
              image: DecorationImage(
                image: AssetImage(image),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        price,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(
                      Icons.star,
                      size: 16,
                      color: Colors.amber,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      rating.toString(),
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  description,
                  style: TextStyle(
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children: tags.map((tag) {
                    return Chip(
                      label: Text(tag),
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTrendingTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 10,
      itemBuilder: (context, index) {
        return _buildTrendingCard(
          title: 'Cherry Blossom Festival',
          location: 'Tokyo, Japan',
          trendingReason: 'Peak season approaching',
          image: 'assets/images/recommendations/cherry_blossom.jpg',
        );
      },
    );
  }

  Widget _buildTrendingCard({
    required String title,
    required String location,
    required String trendingReason,
    required String image,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.horizontal(
                left: Radius.circular(12),
              ),
              image: DecorationImage(
                image: AssetImage(image),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    location,
                    style: TextStyle(
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.orange[100],
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.trending_up,
                          size: 16,
                          color: Colors.orange,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          trendingReason,
                          style: TextStyle(
                            color: Colors.orange[900],
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNearbyTab() {
    return Column(
      children: [
        Container(
          height: 200,
          color: Colors.grey[200],
          child: const Center(
            child: Text('Map View'),
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: 8,
            itemBuilder: (context, index) {
              return _buildNearbyCard(
                title: 'Local Art Gallery',
                distance: '0.5 km',
                rating: 4.5,
                image: 'assets/images/recommendations/art_gallery.jpg',
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildNearbyCard({
    required String title,
    required String distance,
    required double rating,
    required String image,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: ListTile(
        leading: Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            image: DecorationImage(
              image: AssetImage(image),
              fit: BoxFit.cover,
            ),
          ),
        ),
        title: Text(title),
        subtitle: Row(
          children: [
            const Icon(
              Icons.location_on,
              size: 16,
              color: Colors.grey,
            ),
            const SizedBox(width: 4),
            Text(distance),
            const SizedBox(width: 16),
            const Icon(
              Icons.star,
              size: 16,
              color: Colors.amber,
            ),
            const SizedBox(width: 4),
            Text(rating.toString()),
          ],
        ),
        trailing: const Icon(Icons.chevron_right),
        onTap: () {
          // TODO: Navigate to detail page
        },
      ),
    );
  }
}
