import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/weather_provider.dart';

class SearchCityWidget extends StatefulWidget {
  const SearchCityWidget({super.key});

  @override
  State<SearchCityWidget> createState() => _SearchCityWidgetState();
}

class _SearchCityWidgetState extends State<SearchCityWidget> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool _isExpanded = false;
  bool _showSuggestions = false;
  List<String> _filteredCities = [];

  // Danh sách các thành phố phổ biến ở Việt Nam và thế giới
  final List<String> _popularCities = [
    // Việt Nam
    'Hồ Chí Minh',
    'Hà Nội',
    'Đà Nẵng',
    'Hải Phòng',
    'Cần Thơ',
    'Nha Trang',
    'Huế',
    'Vũng Tàu',
    'Đà Lạt',
    'Quy Nhon',
    'Phan Thiết',
    'Long Xuyên',
    'Thái Nguyên',
    'Nam Định',
    'Vinh',
    // Thế giới
    'Tokyo',
    'New York',
    'London',
    'Paris',
    'Seoul',
    'Bangkok',
    'Singapore',
    'Sydney',
    'Los Angeles',
    'Berlin',
    'Rome',
    'Barcelona',
    'Amsterdam',
    'Dubai',
    'Hong Kong',
    'Kuala Lumpur',
    'Manila',
    'Jakarta',
    'Mumbai',
    'Delhi',
  ];

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onSearchChanged);
    _focusNode.addListener(_onFocusChanged);
  }

  @override
  void dispose() {
    _controller.removeListener(_onSearchChanged);
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    final query = _controller.text.toLowerCase();
    if (query.isEmpty) {
      setState(() {
        _filteredCities = [];
        _showSuggestions = false;
      });
    } else {
      setState(() {
        _filteredCities = _popularCities.where((city) => city.toLowerCase().contains(query)).take(5).toList();
        _showSuggestions = _filteredCities.isNotEmpty;
      });
    }
  }

  void _onFocusChanged() {
    if (!_focusNode.hasFocus) {
      // Delay để cho phép tap vào suggestion
      Future.delayed(const Duration(milliseconds: 200), () {
        if (mounted) {
          setState(() {
            _showSuggestions = false;
          });
        }
      });
    }
  }

  void _selectCity(String city) {
    _controller.text = city;
    context.read<WeatherProvider>().updateCity(city);
    _controller.clear();
    setState(() {
      _isExpanded = false;
      _showSuggestions = false;
    });
    _focusNode.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            children: [
              if (_isExpanded) ...[
                Expanded(
                  child: Container(
                    height: 52,
                    decoration: BoxDecoration(
                      color: Colors.white.withAlpha(51),
                      borderRadius: BorderRadius.circular(26),
                      border: Border.all(color: Colors.white.withAlpha(76), width: 1.5),
                      boxShadow: [
                        BoxShadow(color: Colors.black.withAlpha(25), blurRadius: 8, offset: const Offset(0, 4)),
                      ],
                    ),
                    child: TextField(
                      controller: _controller,
                      focusNode: _focusNode,
                      autofocus: true,
                      style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),
                      decoration: InputDecoration(
                        hintText: 'Nhập tên thành phố...',
                        hintStyle: TextStyle(color: Colors.white.withAlpha(179), fontWeight: FontWeight.w400),
                        prefixIcon: Icon(Icons.search_rounded, color: Colors.white.withAlpha(179)),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      ),
                      onSubmitted: (value) {
                        if (value.isNotEmpty) {
                          _selectCity(value);
                        }
                      },
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: () {
                    _controller.clear();
                    setState(() {
                      _isExpanded = false;
                      _showSuggestions = false;
                    });
                    _focusNode.unfocus();
                  },
                  child: Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      color: Colors.white.withAlpha(51),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white.withAlpha(76), width: 1.5),
                      boxShadow: [
                        BoxShadow(color: Colors.black.withAlpha(25), blurRadius: 8, offset: const Offset(0, 4)),
                      ],
                    ),
                    child: Icon(Icons.close_rounded, color: Colors.white.withAlpha(230)),
                  ),
                ),
              ] else ...[
                const Spacer(),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _isExpanded = true;
                    });
                  },
                  child: Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      color: Colors.white.withAlpha(51),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white.withAlpha(76), width: 1.5),
                      boxShadow: [
                        BoxShadow(color: Colors.black.withAlpha(25), blurRadius: 8, offset: const Offset(0, 4)),
                      ],
                    ),
                    child: Icon(Icons.search_rounded, color: Colors.white.withAlpha(230)),
                  ),
                ),
              ],
            ],
          ),

          // Suggestions list
          if (_showSuggestions && _isExpanded) ...[
            const SizedBox(height: 8),
            Container(
              constraints: const BoxConstraints(maxHeight: 200),
              decoration: BoxDecoration(
                color: Colors.white.withAlpha(77),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white.withAlpha(102), width: 1),
                boxShadow: [BoxShadow(color: Colors.black.withAlpha(51), blurRadius: 12, offset: const Offset(0, 4))],
              ),
              child: ListView.builder(
                shrinkWrap: true,
                padding: const EdgeInsets.symmetric(vertical: 8),
                itemCount: _filteredCities.length,
                itemBuilder: (context, index) {
                  final city = _filteredCities[index];
                  return Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () => _selectCity(city),
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        child: Row(
                          children: [
                            Icon(Icons.location_on_rounded, color: Colors.white.withAlpha(204), size: 20),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                city,
                                style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),
                              ),
                            ),
                            Icon(Icons.arrow_forward_ios_rounded, color: Colors.white.withAlpha(153), size: 16),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ],
      ),
    );
  }
}
