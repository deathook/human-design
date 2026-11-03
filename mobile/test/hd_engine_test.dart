import 'package:flutter_test/flutter_test.dart';
import 'package:human_design_app/services/hd_engine.dart';
import 'package:human_design_app/models/chart_data.dart';

void main() {
  test('HDEngine calculates complete Human Design chart offline', () {
    final rawChart = HDEngine.calculateFullChart(
      name: 'Nguyễn Văn A',
      birthDate: '1995-10-25',
      birthTime: '14:30',
      timezone: 'Asia/Ho_Chi_Minh',
    );

    final chart = ChartData.fromJson(rawChart);

    expect(chart.userName, 'Nguyễn Văn A');
    expect(chart.typeName.isNotEmpty, true);
    expect(chart.profileKey.isNotEmpty, true);
    expect(chart.authorityName.isNotEmpty, true);
    expect(chart.definitionName.isNotEmpty, true);

    // Verify all 13 planets in Personality (conscious)
    final personality = chart.activations['personality'] as Map<String, dynamic>;
    expect(personality.length, 13);
    for (final planet in [
      'Sun', 'Earth', 'North_Node', 'South_Node', 'Moon',
      'Mercury', 'Venus', 'Mars', 'Jupiter', 'Saturn',
      'Uranus', 'Neptune', 'Pluto'
    ]) {
      expect(personality.containsKey(planet), true, reason: 'Missing $planet in personality');
      final data = personality[planet] as Map<String, dynamic>;
      expect(data['gate'] is int, true);
      expect(data['line'] is int, true);
      expect(data['arrow'] is String, true);
    }

    // Verify all 13 planets in Design (unconscious)
    final design = chart.activations['design'] as Map<String, dynamic>;
    expect(design.length, 13);
    for (final planet in [
      'Sun', 'Earth', 'North_Node', 'South_Node', 'Moon',
      'Mercury', 'Venus', 'Mars', 'Jupiter', 'Saturn',
      'Uranus', 'Neptune', 'Pluto'
    ]) {
      expect(design.containsKey(planet), true, reason: 'Missing $planet in design');
      final data = design[planet] as Map<String, dynamic>;
      expect(data['gate'] is int, true);
      expect(data['line'] is int, true);
      expect(data['arrow'] is String, true);
    }

    // Verify defined and undefined centers
    expect(chart.definedCenters.isNotEmpty, true);
    expect(chart.centers.length, 9);
    expect(chart.activeGates.isNotEmpty, true);
  });

  test('Hoang Nhat Minh 1985-07-17 23:05', () {
    final rawChart = HDEngine.calculateFullChart(
      name: 'Hoàng Nhật Minh',
      birthDate: '1985-07-17',
      birthTime: '23:05',
      timezone: 'Asia/Ho_Chi_Minh',
    );
    print('Defined centers: ${rawChart['defined_centers']}');
    final p = rawChart['activations']['personality'] as Map<String, dynamic>;
    final d = rawChart['activations']['design'] as Map<String, dynamic>;
    print('--- PERSONALITY ---');
    p.forEach((k, v) => print('$k: ${v['gate']}.${v['line']} (lon: ${v['longitude']})'));
    print('--- DESIGN ---');
    d.forEach((k, v) => print('$k: ${v['gate']}.${v['line']} (lon: ${v['longitude']})'));
    print('Active channels: ${rawChart['active_channels']}');
  });
}
