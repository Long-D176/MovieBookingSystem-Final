from fastapi import FastAPI, Depends, HTTPException
from sqlalchemy.orm import Session, joinedload
from typing import List, Optional
import models
from database import engine, get_db
from fastapi.middleware.cors import CORSMiddleware

app = FastAPI(title="Catalog Service")

# Cấu hình CORS
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

models.Base.metadata.create_all(bind=engine)

@app.get("/")
def health_check():
    return {"status": "Catalog Service is running"}

@app.get("/movies")
def get_movies(status: str = None, search: str = None, db: Session = Depends(get_db)):
    """
    API lấy danh sách phim.
    - status: Lọc theo trạng thái (NOW_SHOWING, COMING_SOON)
    - search: Lọc theo tên phim (Tìm gần đúng - Like)
    """
    query = db.query(models.Movie)
    
    if status:
        query = query.filter(models.Movie.status == status)
        
    if search:
        query = query.filter(models.Movie.title.ilike(f"%{search}%"))
        
    return query.all()

@app.get("/movies/{movie_id}")
def get_movie_detail(movie_id: int, db: Session = Depends(get_db)):
    movie = db.query(models.Movie).filter(models.Movie.movie_id == movie_id).first()
    if not movie:
        raise HTTPException(status_code=404, detail="Movie not found")
    return movie

@app.get("/movies/{movie_id}/showtimes")
def get_movie_showtimes(movie_id: int, db: Session = Depends(get_db)):
    showtimes = db.query(models.Showtime)\
        .options(joinedload(models.Showtime.screen).joinedload(models.Screen.cinema))\
        .filter(models.Showtime.movie_id == movie_id)\
        .all()
    
    results = []
    for st in showtimes:
        results.append({
            "showtime_id": st.showtime_id,
            "start_time": st.start_time,
            "base_price": st.base_price,
            "screen_id": st.screen_id,
            "screen_name": st.screen.name,
            "cinema_name": st.screen.cinema.name,
            "cinema_id": st.screen.cinema.cinema_id
        })
    return results

@app.get("/showtimes/{showtime_id}")
def get_showtime_detail(showtime_id: int, db: Session = Depends(get_db)):
    """
    API lấy chi tiết một suất chiếu.
    Quan trọng: Cần trả về screen_id để Booking Service tra cứu sơ đồ ghế.
    """
    st = db.query(models.Showtime)\
        .options(joinedload(models.Showtime.movie), joinedload(models.Showtime.screen).joinedload(models.Screen.cinema))\
        .filter(models.Showtime.showtime_id == showtime_id)\
        .first()
        
    if not st:
        raise HTTPException(status_code=404, detail="Showtime not found")
        
    return {
        "showtime_id": st.showtime_id,
        "movie_title": st.movie.title,
        "cinema_name": st.screen.cinema.name,
        "screen_name": st.screen.name,
        "screen_id": st.screen_id, 
        "start_time": st.start_time,
        "poster_url": st.movie.poster_url 
    }

@app.get("/screens/{screen_id}/seats")
def get_screen_seats(screen_id: int, db: Session = Depends(get_db)):
    """Trả về danh sách ghế kèm loại và trạng thái active"""
    seats = db.query(models.Seat).filter(models.Seat.screen_id == screen_id).all()
    return seats

@app.get("/concessions")
def get_concessions(db: Session = Depends(get_db)):
    return db.query(models.ConcessionItem).all()

@app.get("/seat-types")
def get_seat_types(db: Session = Depends(get_db)):
    return db.query(models.SeatType).all()