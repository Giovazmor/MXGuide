import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/places_provider.dart';
import '../../widgets/loading_indicator.dart';
import '../../widgets/place_list_row.dart';
import '../place_detail/place_detail_screen.dart';

class PlacesListScreen extends StatefulWidget {
  const PlacesListScreen({super.key});

  @override
  State<PlacesListScreen> createState() => _PlacesListScreenState();
}

class _PlacesListScreenState extends State<PlacesListScreen> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final placesProvider = context.watch<PlacesProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Ubicaciones')),
      body: RefreshIndicator(
        onRefresh: placesProvider.refresh,
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(child: _buildSearchBar(context, placesProvider)),
            SliverToBoxAdapter(child: _buildCategoryFilters(context, placesProvider)),
            SliverToBoxAdapter(child: _buildStateFilter(context, placesProvider)),
            if (placesProvider.isLoading)
              const SliverFillRemaining(child: LoadingIndicator())
            else if (placesProvider.errorMessage != null)
              SliverFillRemaining(
                child: Center(child: Text(placesProvider.errorMessage!)),
              )
            else if (placesProvider.places.isEmpty)
              const SliverFillRemaining(
                child: Center(child: Text('No hay lugares con esos filtros')),
              )
            else
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final place = placesProvider.places[index];
                      return Column(
                        children: [
                          PlaceListRow(
                            place: place,
                            onTap: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => PlaceDetailScreen(placeId: place.id),
                              ),
                            ),
                          ),
                          if (index < placesProvider.places.length - 1) const Divider(height: 1),
                        ],
                      );
                    },
                    childCount: placesProvider.places.length,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context, PlacesProvider provider) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Buscar lugares...',
          prefixIcon: const Icon(Icons.search),
          filled: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
        ),
        onSubmitted: (value) => provider.applyFilters(
          categoryId: provider.selectedCategoryId,
          stateId: provider.selectedStateId,
          search: value,
        ),
      ),
    );
  }

  Widget _buildCategoryFilters(BuildContext context, PlacesProvider provider) {
    return SizedBox(
      height: 44,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        children: [
          _FilterChip(
            label: 'Todas',
            selected: provider.selectedCategoryId == null,
            onSelected: () => provider.applyFilters(
              categoryId: null,
              stateId: provider.selectedStateId,
            ),
          ),
          ...provider.categories.map(
            (category) => _FilterChip(
              label: category.name,
              selected: provider.selectedCategoryId == category.id,
              onSelected: () => provider.applyFilters(
                categoryId: category.id,
                stateId: provider.selectedStateId,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStateFilter(BuildContext context, PlacesProvider provider) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 4),
      child: DropdownButtonFormField<String>(
        value: provider.selectedStateId,
        decoration: InputDecoration(
          labelText: 'Estado',
          filled: true,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
        items: [
          const DropdownMenuItem<String>(value: null, child: Text('Todos los estados')),
          ...provider.states.map(
            (state) => DropdownMenuItem<String>(value: state.id, child: Text(state.name)),
          ),
        ],
        onChanged: (value) => provider.applyFilters(
          categoryId: provider.selectedCategoryId,
          stateId: value,
        ),
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onSelected;

  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: ChoiceChip(
        label: Text(label),
        selected: selected,
        onSelected: (_) => onSelected(),
      ),
    );
  }
}
