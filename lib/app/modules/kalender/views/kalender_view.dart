import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/kalender_controller.dart';

class KalenderView extends GetView<KalenderController> {
  const KalenderView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF6C1FB4),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'Kalender',
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: Colors.white, size: 28),
            onPressed: () => controller.navigateToAddEvent(),
          ),
        ],
      ),
      body: Column(
        children: [
          // Calendar header
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.grey[50],
            child: Obx(() => Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: () => controller.previousMonth(),
                  icon: const Icon(Icons.chevron_left, size: 28),
                ),
                Text(
                  controller.getMonthYear(),
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
                IconButton(
                  onPressed: () => controller.nextMonth(),
                  icon: const Icon(Icons.chevron_right, size: 28),
                ),
              ],
            )),
          ),
          
          // Calendar grid
          Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Days of week
                Row(
                  children: ['Min', 'Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab']
                      .map((day) => Expanded(
                            child: Center(
                              child: Text(
                                day,
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ),
                          ))
                      .toList(),
                ),
                const SizedBox(height: 8),
                
                // Calendar dates
                Container(
                  height: 250,
                  child: Obx(() => _buildCalendarGrid()),
                ),
              ],
            ),
          ),
          
          // Events section
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey[50],
                border: Border(
                  top: BorderSide(color: Colors.grey[300]!),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Obx(() => Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      controller.isToday() ? 'Acara Hari Ini' : 'Acara ${controller.getSelectedDateString()}',
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                  )),
                  
                  Expanded(
                    child: Obx(() => _buildEventsList()),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCalendarGrid() {
    final firstDayOfMonth = DateTime(controller.selectedDate.value.year, controller.selectedDate.value.month, 1);
    final lastDayOfMonth = DateTime(controller.selectedDate.value.year, controller.selectedDate.value.month + 1, 0);
    final firstWeekday = firstDayOfMonth.weekday % 7;
    
    List<Widget> calendarDays = [];
    
    // Empty cells for days before the first day of month
    for (int i = 0; i < firstWeekday; i++) {
      calendarDays.add(const SizedBox());
    }
    
    // Days of the month
    for (int day = 1; day <= lastDayOfMonth.day; day++) {
      final date = DateTime(controller.selectedDate.value.year, controller.selectedDate.value.month, day);
      final hasEvents = controller.hasEventsOnDate(date);
      final isToday = controller.isSameDay(date, DateTime.now());
      final isSelected = controller.isSameDay(date, controller.selectedDate.value);
      
      calendarDays.add(
        GestureDetector(
          onTap: () => controller.selectDate(date),
          child: Container(
            margin: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              color: isSelected 
                  ? const Color(0xFF6C1FB4)
                  : isToday 
                      ? const Color(0xFF6C1FB4).withOpacity(0.2)
                      : Colors.transparent,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  day.toString(),
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: isSelected 
                        ? Colors.white 
                        : isToday 
                            ? const Color(0xFF6C1FB4)
                            : Colors.black,
                  ),
                ),
                if (hasEvents)
                  Container(
                    margin: const EdgeInsets.only(top: 2),
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.white : const Color(0xFF6C1FB4),
                      shape: BoxShape.circle,
                    ),
                  ),
              ],
            ),
          ),
        ),
      );
    }
    
    return GridView.count(
      crossAxisCount: 7,
      children: calendarDays,
    );
  }

  Widget _buildEventsList() {
    final todayEvents = controller.getEventsForSelectedDate();
    
    if (todayEvents.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.event_note,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'Tidak ada acara pada tanggal ini',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: todayEvents.length,
      itemBuilder: (context, index) {
        final event = todayEvents[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                blurRadius: 4,
                spreadRadius: 1,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 4,
                height: 40,
                decoration: BoxDecoration(
                  color: event.color,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      event.title,
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on_outlined,
                          size: 16,
                          color: Colors.grey[600],
                        ),
                        const SizedBox(width: 4),
                        Text(
                          event.location,
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(width: 16),
                        Icon(
                          Icons.access_time,
                          size: 16,
                          color: Colors.grey[600],
                        ),
                        const SizedBox(width: 4),
                        Text(
                          event.time,
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              PopupMenuButton(
                icon: const Icon(Icons.more_vert, color: Colors.grey),
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 'edit',
                    child: const Text('Edit'),
                    onTap: () => controller.editEvent(event),
                  ),
                  PopupMenuItem(
                    value: 'delete',
                    child: const Text('Hapus'),
                    onTap: () => controller.deleteEvent(event),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}