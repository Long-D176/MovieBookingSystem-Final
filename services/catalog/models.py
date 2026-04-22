from sqlalchemy import Column, Integer, String, Enum, DateTime, ForeignKey, DECIMAL, Boolean
from sqlalchemy.orm import relationship
from database import Base

class Cinema(Base):
    __tablename__ = "cinemas"
    cinema_id = Column(Integer, primary_key=True, index=True)
    name = Column(String(100))
    address = Column(String(255))

class Screen(Base):
    __tablename__ = "screens"
    screen_id = Column(Integer, primary_key=True, index=True)
    cinema_id = Column(Integer, ForeignKey("cinemas.cinema_id"))
    name = Column(String(50))
    total_seats = Column(Integer)
    cinema = relationship("Cinema")

class Movie(Base):
    __tablename__ = "movies"
    movie_id = Column(Integer, primary_key=True, index=True)
    title = Column(String(255))
    duration_minutes = Column(Integer)
    status = Column(String(50))
    poster_url = Column(String(500))

class Showtime(Base):
    __tablename__ = "showtimes"
    showtime_id = Column(Integer, primary_key=True, index=True)
    movie_id = Column(Integer, ForeignKey("movies.movie_id"))
    screen_id = Column(Integer, ForeignKey("screens.screen_id"))
    start_time = Column(DateTime)
    base_price = Column(DECIMAL(10, 2))
    movie = relationship("Movie")
    screen = relationship("Screen")

class SeatType(Base):
    __tablename__ = "seat_types"
    seat_type_id = Column(Integer, primary_key=True, index=True)
    name = Column(String(50))
    surcharge_rate = Column(DECIMAL(10, 2))

class Seat(Base):
    __tablename__ = "seats"
    seat_id = Column(Integer, primary_key=True, index=True)
    screen_id = Column(Integer, ForeignKey("screens.screen_id"))
    seat_type_id = Column(Integer, ForeignKey("seat_types.seat_type_id"))
    row_code = Column(String(10))
    seat_number = Column(Integer)
    is_active = Column(Boolean, default=True) 
    
    seat_type = relationship("SeatType")

class ConcessionItem(Base):
    __tablename__ = "concession_items"
    item_id = Column(Integer, primary_key=True, index=True)
    name = Column(String(100))
    price = Column(DECIMAL(10, 2))