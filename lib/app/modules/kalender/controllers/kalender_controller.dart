import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Event {
  final String title;
  final String location;
  final String time;
  final Color color;

  Event(this.title, this.location, this.time, this.color);

  // For comparison and operations
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Event &&
           other.title == title &&
           other.location == location &&
           other.time == time;
  }

  @override
  int get hashCode => title.hashCode ^ location.hashCode ^ time.hashCode;

  // Convert to Map for easier handling
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'location': location,
      'time': time,
      'color': color.value,
    };
  }

  // Create from Map
  factory Event.fromMap(Map<String, dynamic> map) {
    return Event(
      map['title'] ?? '',
      map['location'] ?? '',
      map['time'] ?? '',
      Color(map['color'] ?? Colors.blue.value),
    );
  }
}

class KalenderController extends GetxController {
  // Observable variables
  final Rx<DateTime> selectedDate = DateTime.now().obs;
  final RxMap<DateTime, List<Event>> events = <DateTime, List<Event>>{}.obs;

  // Month names in Indonesian
  final List<String> monthNames = [
    'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
    'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'
  ];

  @override
  void onInit() {
    super.onInit();
    initializeEvents();
  }

  void initializeEvents() {
    // Initialize with sample data
    events.addAll({
      DateTime(2025, 5, 22): [
        Event('Ulangan Matematika', 'X RPL B', '08:00', Colors.red),
        Event('Presentasi Proyek', 'X RPL A', '10:00', Colors.blue),
      ],
      DateTime(2025, 5, 23): [
        Event('Deadline Tugas Essay', 'X RPL A', '23:59', Colors.orange),
      ],
      DateTime(2025, 5, 25): [
        Event('Ujian Tengah Semester', 'Semua Kelas', '08:00', Colors.red),
      ],
      DateTime(2025, 5, 26): [
        Event('Rapat Guru', 'Ruang Guru', '14:00', Colors.green),
      ],
    });
  }

  // Navigation methods
  void previousMonth() {
    selectedDate.value = DateTime(selectedDate.value.year, selectedDate.value.month - 1);
  }

  void nextMonth() {
    selectedDate.value = DateTime(selectedDate.value.year, selectedDate.value.month + 1);
  }

  void selectDate(DateTime date) {
    selectedDate.value = date;
  }

  // Date utility methods
  String getMonthYear() {
    return '${monthNames[selectedDate.value.month - 1]} ${selectedDate.value.year}';
  }

  String getSelectedDateString() {
    return '${selectedDate.value.day} ${monthNames[selectedDate.value.month - 1]} ${selectedDate.value.year}';
  }

  bool isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
           date1.month == date2.month &&
           date1.day == date2.day;
  }

  bool isToday() {
    return isSameDay(selectedDate.value, DateTime.now());
  }

  bool hasEventsOnDate(DateTime date) {
    return events.containsKey(DateTime(date.year, date.month, date.day));
  }

  // Event management methods
  List<Event> getEventsForSelectedDate() {
    final dateKey = DateTime(selectedDate.value.year, selectedDate.value.month, selectedDate.value.day);
    return events[dateKey] ?? [];
  }

  List<Event> getEventsForDate(DateTime date) {
    final dateKey = DateTime(date.year, date.month, date.day);
    return events[dateKey] ?? [];
  }

  void addEvent(DateTime date, Event event) {
    final dateKey = DateTime(date.year, date.month, date.day);
    if (events.containsKey(dateKey)) {
      events[dateKey]!.add(event);
    } else {
      events[dateKey] = [event];
    }
    events.refresh(); // Trigger UI update
  }

  void removeEvent(DateTime date, Event event) {
    final dateKey = DateTime(date.year, date.month, date.day);
    if (events.containsKey(dateKey)) {
      events[dateKey]!.remove(event);
      if (events[dateKey]!.isEmpty) {
        events.remove(dateKey);
      }
    }
    events.refresh(); // Trigger UI update
  }

  void updateEvent(DateTime date, Event oldEvent, Event newEvent) {
    removeEvent(date, oldEvent);
    addEvent(date, newEvent);
  }

  // Navigation methods
  void navigateToAddEvent() {
    Get.toNamed('/tambah-event', arguments: {
      'selectedDate': selectedDate.value,
      'controller': this,
    });
  }

  void editEvent(Event event) {
    Get.dialog(
      AlertDialog(
        title: const Text('Edit Event'),
        content: Text('Mengedit event: ${event.title}'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              // Navigate to edit event page
              Get.toNamed('/edit-event', arguments: {
                'event': event,
                'date': selectedDate.value,
                'controller': this,
              });
            },
            child: const Text('Edit'),
          ),
        ],
      ),
    );
  }

  void deleteEvent(Event event) {
    Get.dialog(
      AlertDialog(
        title: const Text('Hapus Event'),
        content: Text('Apakah Anda yakin ingin menghapus event "${event.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () {
              removeEvent(selectedDate.value, event);
              Get.back();
              Get.snackbar(
                'Berhasil',
                'Event berhasil dihapus',
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: Colors.green,
                colorText: Colors.white,
              );
            },
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }

  // Filter events by type/category (if needed)
  List<Event> getEventsByType(String type) {
    List<Event> filteredEvents = [];
    events.forEach((date, eventList) {
      // Add filtering logic based on event type if needed
      filteredEvents.addAll(eventList);
    });
    return filteredEvents;
  }

  // Get all events for current month
  List<Event> getCurrentMonthEvents() {
    List<Event> monthEvents = [];
    events.forEach((date, eventList) {
      if (date.year == selectedDate.value.year && 
          date.month == selectedDate.value.month) {
        monthEvents.addAll(eventList);
      }
    });
    return monthEvents;
  }

  // Search events
  List<Event> searchEvents(String query) {
    List<Event> searchResults = [];
    events.forEach((date, eventList) {
      for (Event event in eventList) {
        if (event.title.toLowerCase().contains(query.toLowerCase()) ||
            event.location.toLowerCase().contains(query.toLowerCase())) {
          searchResults.add(event);
        }
      }
    });
    return searchResults;
  }

  // Get events count for a specific date
  int getEventsCountForDate(DateTime date) {
    return getEventsForDate(date).length;
  }

  // Check if date has events of specific color/type
  bool hasEventOfColor(DateTime date, Color color) {
    final dayEvents = getEventsForDate(date);
    return dayEvents.any((event) => event.color == color);
  }
}