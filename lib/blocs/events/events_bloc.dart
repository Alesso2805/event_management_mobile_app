import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/event.dart';
import '../../services/event_service.dart';

// Events
abstract class EventsEvent extends Equatable {
  const EventsEvent();

  @override
  List<Object?> get props => [];
}

class EventsLoadRequested extends EventsEvent {
  final int page;
  final String? category;
  final String? search;
  final String? city;
  final DateTime? startDate;
  final DateTime? endDate;

  const EventsLoadRequested({
    this.page = 0,
    this.category,
    this.search,
    this.city,
    this.startDate,
    this.endDate,
  });

  @override
  List<Object?> get props => [page, category, search, city, startDate, endDate];
}

class EventsRefreshRequested extends EventsEvent {}

class EventDetailsLoadRequested extends EventsEvent {
  final int eventId;

  const EventDetailsLoadRequested({required this.eventId});

  @override
  List<Object> get props => [eventId];
}

class EventCreateRequested extends EventsEvent {
  final String title;
  final String description;
  final DateTime eventDate;
  final DateTime? eventEndDate;
  final String location;
  final String? city;
  final String? state;
  final String? country;
  final double? latitude;
  final double? longitude;
  final bool isVirtual;
  final String? virtualUrl;
  final int maxCapacity;
  final int categoryId;
  final List<CreateTicketTypeRequest> ticketTypes;

  const EventCreateRequested({
    required this.title,
    required this.description,
    required this.eventDate,
    this.eventEndDate,
    required this.location,
    this.city,
    this.state,
    this.country,
    this.latitude,
    this.longitude,
    required this.isVirtual,
    this.virtualUrl,
    required this.maxCapacity,
    required this.categoryId,
    required this.ticketTypes,
  });

  @override
  List<Object?> get props => [
        title,
        description,
        eventDate,
        eventEndDate,
        location,
        city,
        state,
        country,
        latitude,
        longitude,
        isVirtual,
        virtualUrl,
        maxCapacity,
        categoryId,
        ticketTypes,
      ];
}

class EventUpdateRequested extends EventsEvent {
  final int eventId;
  final String? title;
  final String? description;
  final DateTime? eventDate;
  final DateTime? eventEndDate;
  final String? location;
  final String? city;
  final String? state;
  final String? country;
  final double? latitude;
  final double? longitude;
  final bool? isVirtual;
  final String? virtualUrl;
  final int? maxCapacity;
  final int? categoryId;
  final List<CreateTicketTypeRequest>? ticketTypes;

  const EventUpdateRequested({
    required this.eventId,
    this.title,
    this.description,
    this.eventDate,
    this.eventEndDate,
    this.location,
    this.city,
    this.state,
    this.country,
    this.latitude,
    this.longitude,
    this.isVirtual,
    this.virtualUrl,
    this.maxCapacity,
    this.categoryId,
    this.ticketTypes,
  });

  @override
  List<Object?> get props => [
        eventId,
        title,
        description,
        eventDate,
        eventEndDate,
        location,
        city,
        state,
        country,
        latitude,
        longitude,
        isVirtual,
        virtualUrl,
        maxCapacity,
        categoryId,
        ticketTypes,
      ];
}

class EventDeleteRequested extends EventsEvent {
  final int eventId;

  const EventDeleteRequested({required this.eventId});

  @override
  List<Object> get props => [eventId];
}

class EventPublishRequested extends EventsEvent {
  final int eventId;

  const EventPublishRequested({required this.eventId});

  @override
  List<Object> get props => [eventId];
}

class EventCancelRequested extends EventsEvent {
  final int eventId;

  const EventCancelRequested({required this.eventId});

  @override
  List<Object> get props => [eventId];
}

class EventFavoriteToggleRequested extends EventsEvent {
  final int eventId;
  final bool isFavorite;

  const EventFavoriteToggleRequested({
    required this.eventId,
    required this.isFavorite,
  });

  @override
  List<Object> get props => [eventId, isFavorite];
}

class MyEventsLoadRequested extends EventsEvent {
  final int page;
  final EventStatus? status;

  const MyEventsLoadRequested({
    this.page = 0,
    this.status,
  });

  @override
  List<Object?> get props => [page, status];
}

class FavoriteEventsLoadRequested extends EventsEvent {
  final int page;

  const FavoriteEventsLoadRequested({
    this.page = 0,
  });

  @override
  List<Object> get props => [page];
}

class NearbyEventsLoadRequested extends EventsEvent {
  final double latitude;
  final double longitude;
  final double radius;
  final int page;

  const NearbyEventsLoadRequested({
    required this.latitude,
    required this.longitude,
    this.radius = 10.0,
    this.page = 0,
  });

  @override
  List<Object> get props => [latitude, longitude, radius, page];
}

class EventsSearchRequested extends EventsEvent {
  final String query;
  final int page;
  final String? category;
  final String? city;
  final DateTime? startDate;
  final DateTime? endDate;

  const EventsSearchRequested({
    required this.query,
    this.page = 0,
    this.category,
    this.city,
    this.startDate,
    this.endDate,
  });

  @override
  List<Object?> get props => [query, page, category, city, startDate, endDate];
}

// States
abstract class EventsState extends Equatable {
  const EventsState();

  @override
  List<Object?> get props => [];
}

class EventsInitial extends EventsState {}

class EventsLoading extends EventsState {}

class EventsLoaded extends EventsState {
  final List<Event> events;
  final bool hasReachedMax;
  final int currentPage;

  const EventsLoaded({
    required this.events,
    this.hasReachedMax = false,
    this.currentPage = 0,
  });

  EventsLoaded copyWith({
    List<Event>? events,
    bool? hasReachedMax,
    int? currentPage,
  }) {
    return EventsLoaded(
      events: events ?? this.events,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      currentPage: currentPage ?? this.currentPage,
    );
  }

  @override
  List<Object> get props => [events, hasReachedMax, currentPage];
}

class EventDetailsLoading extends EventsState {}

class EventDetailsLoaded extends EventsState {
  final Event event;

  const EventDetailsLoaded({required this.event});

  @override
  List<Object> get props => [event];
}

class EventCreated extends EventsState {
  final Event event;

  const EventCreated({required this.event});

  @override
  List<Object> get props => [event];
}

class EventUpdated extends EventsState {
  final Event event;

  const EventUpdated({required this.event});

  @override
  List<Object> get props => [event];
}

class EventDeleted extends EventsState {
  final int eventId;

  const EventDeleted({required this.eventId});

  @override
  List<Object> get props => [eventId];
}

class EventPublished extends EventsState {
  final Event event;

  const EventPublished({required this.event});

  @override
  List<Object> get props => [event];
}

class EventCancelled extends EventsState {
  final Event event;

  const EventCancelled({required this.event});

  @override
  List<Object> get props => [event];
}

class EventFavoriteToggled extends EventsState {
  final int eventId;
  final bool isFavorite;

  const EventFavoriteToggled({
    required this.eventId,
    required this.isFavorite,
  });

  @override
  List<Object> get props => [eventId, isFavorite];
}

class EventsError extends EventsState {
  final String message;

  const EventsError({required this.message});

  @override
  List<Object> get props => [message];
}

// Bloc
class EventsBloc extends Bloc<EventsEvent, EventsState> {
  final EventService eventService;

  EventsBloc({required this.eventService}) : super(EventsInitial()) {
    on<EventsLoadRequested>(_onEventsLoadRequested);
    on<EventsRefreshRequested>(_onEventsRefreshRequested);
    on<EventDetailsLoadRequested>(_onEventDetailsLoadRequested);
    on<EventCreateRequested>(_onEventCreateRequested);
    on<EventUpdateRequested>(_onEventUpdateRequested);
    on<EventDeleteRequested>(_onEventDeleteRequested);
    on<EventPublishRequested>(_onEventPublishRequested);
    on<EventCancelRequested>(_onEventCancelRequested);
    on<EventFavoriteToggleRequested>(_onEventFavoriteToggleRequested);
    on<MyEventsLoadRequested>(_onMyEventsLoadRequested);
    on<FavoriteEventsLoadRequested>(_onFavoriteEventsLoadRequested);
    on<NearbyEventsLoadRequested>(_onNearbyEventsLoadRequested);
    on<EventsSearchRequested>(_onEventsSearchRequested);
  }

  Future<void> _onEventsLoadRequested(
    EventsLoadRequested event,
    Emitter<EventsState> emit,
  ) async {
    try {
      if (event.page == 0) {
        emit(EventsLoading());
      }

      final events = await eventService.getPublicEvents(
        page: event.page,
        category: event.category,
        search: event.search,
        city: event.city,
        startDate: event.startDate,
        endDate: event.endDate,
      );

      if (state is EventsLoaded && event.page > 0) {
        final currentState = state as EventsLoaded;
        final allEvents = List<Event>.from(currentState.events)..addAll(events);
        
        emit(EventsLoaded(
          events: allEvents,
          hasReachedMax: events.isEmpty,
          currentPage: event.page,
        ));
      } else {
        emit(EventsLoaded(
          events: events,
          hasReachedMax: events.isEmpty,
          currentPage: event.page,
        ));
      }
    } catch (e) {
      emit(EventsError(message: e.toString()));
    }
  }

  Future<void> _onEventsRefreshRequested(
    EventsRefreshRequested event,
    Emitter<EventsState> emit,
  ) async {
    try {
      emit(EventsLoading());
      
      final events = await eventService.getPublicEvents(page: 0);
      
      emit(EventsLoaded(
        events: events,
        hasReachedMax: events.isEmpty,
        currentPage: 0,
      ));
    } catch (e) {
      emit(EventsError(message: e.toString()));
    }
  }

  Future<void> _onEventDetailsLoadRequested(
    EventDetailsLoadRequested event,
    Emitter<EventsState> emit,
  ) async {
    try {
      emit(EventDetailsLoading());
      
      final eventDetails = await eventService.getEventDetails(event.eventId);
      
      emit(EventDetailsLoaded(event: eventDetails));
    } catch (e) {
      emit(EventsError(message: e.toString()));
    }
  }

  Future<void> _onEventCreateRequested(
    EventCreateRequested event,
    Emitter<EventsState> emit,
  ) async {
    try {
      emit(EventsLoading());
      
      final createdEvent = await eventService.createEvent(
        title: event.title,
        description: event.description,
        eventDate: event.eventDate,
        eventEndDate: event.eventEndDate,
        location: event.location,
        city: event.city,
        state: event.state,
        country: event.country,
        latitude: event.latitude,
        longitude: event.longitude,
        isVirtual: event.isVirtual,
        virtualUrl: event.virtualUrl,
        maxCapacity: event.maxCapacity,
        categoryId: event.categoryId,
        ticketTypes: event.ticketTypes,
      );
      
      emit(EventCreated(event: createdEvent));
    } catch (e) {
      emit(EventsError(message: e.toString()));
    }
  }

  Future<void> _onEventUpdateRequested(
    EventUpdateRequested event,
    Emitter<EventsState> emit,
  ) async {
    try {
      emit(EventsLoading());
      
      final updatedEvent = await eventService.updateEvent(
        eventId: event.eventId,
        title: event.title,
        description: event.description,
        eventDate: event.eventDate,
        eventEndDate: event.eventEndDate,
        location: event.location,
        city: event.city,
        state: event.state,
        country: event.country,
        latitude: event.latitude,
        longitude: event.longitude,
        isVirtual: event.isVirtual,
        virtualUrl: event.virtualUrl,
        maxCapacity: event.maxCapacity,
        categoryId: event.categoryId,
        ticketTypes: event.ticketTypes,
      );
      
      emit(EventUpdated(event: updatedEvent));
    } catch (e) {
      emit(EventsError(message: e.toString()));
    }
  }

  Future<void> _onEventDeleteRequested(
    EventDeleteRequested event,
    Emitter<EventsState> emit,
  ) async {
    try {
      emit(EventsLoading());
      
      await eventService.deleteEvent(event.eventId);
      
      emit(EventDeleted(eventId: event.eventId));
    } catch (e) {
      emit(EventsError(message: e.toString()));
    }
  }

  Future<void> _onEventPublishRequested(
    EventPublishRequested event,
    Emitter<EventsState> emit,
  ) async {
    try {
      emit(EventsLoading());
      
      final publishedEvent = await eventService.publishEvent(event.eventId);
      
      emit(EventPublished(event: publishedEvent));
    } catch (e) {
      emit(EventsError(message: e.toString()));
    }
  }

  Future<void> _onEventCancelRequested(
    EventCancelRequested event,
    Emitter<EventsState> emit,
  ) async {
    try {
      emit(EventsLoading());
      
      final cancelledEvent = await eventService.cancelEvent(event.eventId);
      
      emit(EventCancelled(event: cancelledEvent));
    } catch (e) {
      emit(EventsError(message: e.toString()));
    }
  }

  Future<void> _onEventFavoriteToggleRequested(
    EventFavoriteToggleRequested event,
    Emitter<EventsState> emit,
  ) async {
    try {
      bool success;
      
      if (event.isFavorite) {
        success = await eventService.removeFromFavorites(event.eventId);
      } else {
        success = await eventService.addToFavorites(event.eventId);
      }
      
      if (success) {
        emit(EventFavoriteToggled(
          eventId: event.eventId,
          isFavorite: !event.isFavorite,
        ));
      }
    } catch (e) {
      emit(EventsError(message: e.toString()));
    }
  }

  Future<void> _onMyEventsLoadRequested(
    MyEventsLoadRequested event,
    Emitter<EventsState> emit,
  ) async {
    try {
      if (event.page == 0) {
        emit(EventsLoading());
      }

      final events = await eventService.getMyEvents(
        page: event.page,
        status: event.status,
      );

      if (state is EventsLoaded && event.page > 0) {
        final currentState = state as EventsLoaded;
        final allEvents = List<Event>.from(currentState.events)..addAll(events);
        
        emit(EventsLoaded(
          events: allEvents,
          hasReachedMax: events.isEmpty,
          currentPage: event.page,
        ));
      } else {
        emit(EventsLoaded(
          events: events,
          hasReachedMax: events.isEmpty,
          currentPage: event.page,
        ));
      }
    } catch (e) {
      emit(EventsError(message: e.toString()));
    }
  }

  Future<void> _onFavoriteEventsLoadRequested(
    FavoriteEventsLoadRequested event,
    Emitter<EventsState> emit,
  ) async {
    try {
      if (event.page == 0) {
        emit(EventsLoading());
      }

      final events = await eventService.getFavoriteEvents(
        page: event.page,
      );

      if (state is EventsLoaded && event.page > 0) {
        final currentState = state as EventsLoaded;
        final allEvents = List<Event>.from(currentState.events)..addAll(events);
        
        emit(EventsLoaded(
          events: allEvents,
          hasReachedMax: events.isEmpty,
          currentPage: event.page,
        ));
      } else {
        emit(EventsLoaded(
          events: events,
          hasReachedMax: events.isEmpty,
          currentPage: event.page,
        ));
      }
    } catch (e) {
      emit(EventsError(message: e.toString()));
    }
  }

  Future<void> _onNearbyEventsLoadRequested(
    NearbyEventsLoadRequested event,
    Emitter<EventsState> emit,
  ) async {
    try {
      if (event.page == 0) {
        emit(EventsLoading());
      }

      final events = await eventService.getNearbyEvents(
        latitude: event.latitude,
        longitude: event.longitude,
        radius: event.radius,
        page: event.page,
      );

      if (state is EventsLoaded && event.page > 0) {
        final currentState = state as EventsLoaded;
        final allEvents = List<Event>.from(currentState.events)..addAll(events);
        
        emit(EventsLoaded(
          events: allEvents,
          hasReachedMax: events.isEmpty,
          currentPage: event.page,
        ));
      } else {
        emit(EventsLoaded(
          events: events,
          hasReachedMax: events.isEmpty,
          currentPage: event.page,
        ));
      }
    } catch (e) {
      emit(EventsError(message: e.toString()));
    }
  }

  Future<void> _onEventsSearchRequested(
    EventsSearchRequested event,
    Emitter<EventsState> emit,
  ) async {
    try {
      if (event.page == 0) {
        emit(EventsLoading());
      }

      final events = await eventService.searchEvents(
        query: event.query,
        page: event.page,
        category: event.category,
        city: event.city,
        startDate: event.startDate,
        endDate: event.endDate,
      );

      if (state is EventsLoaded && event.page > 0) {
        final currentState = state as EventsLoaded;
        final allEvents = List<Event>.from(currentState.events)..addAll(events);
        
        emit(EventsLoaded(
          events: allEvents,
          hasReachedMax: events.isEmpty,
          currentPage: event.page,
        ));
      } else {
        emit(EventsLoaded(
          events: events,
          hasReachedMax: events.isEmpty,
          currentPage: event.page,
        ));
      }
    } catch (e) {
      emit(EventsError(message: e.toString()));
    }
  }
}
