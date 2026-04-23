from fastapi import FastAPI, Depends, HTTPException, Header
from sqlalchemy.orm import Session, joinedload
from pydantic import BaseModel
import models
from database import engine, get_db
from jose import jwt
from fastapi.middleware.cors import CORSMiddleware
from sqlalchemy import func
from datetime import datetime
from typing import List
from fastapi.security import HTTPBearer, HTTPAuthorizationCredentials
import os

app = FastAPI(title="Management Service")

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

models.Base.metadata.create_all(bind=engine)

# --- SECURITY ---
SECRET_KEY = os.getenv("JWT_SECRET", "change-this-in-production")
ALGORITHM = "HS256"

security = HTTPBearer()

def check_admin_role(credentials: HTTPAuthorizationCredentials = Depends(security)):
    """
    Dependency xác thực quyền Admin.
    Sử dụng HTTPBearer để hiện nút Authorize trên Swagger.
    """
    token = credentials.credentials
    try:
        # Giải mã Token
        payload = jwt.decode(token, SECRET_KEY, algorithms=[ALGORITHM])
        role = payload.get("role")
        
        # Kiểm tra quyền
        if role not in ["ADMIN", "MANAGER"]:
            raise HTTPException(status_code=403, detail="Không có quyền truy cập! Yêu cầu quyền ADMIN.")
            
        return payload
    except:
        raise HTTPException(status_code=401, detail="Token không hợp lệ hoặc đã hết hạn.")

# --- SCHEMAS ---
class MovieCreate(BaseModel):
    title: str
    duration_minutes: int
    status: str
    poster_url: str

class MovieStatusUpdate(BaseModel):
    status: str 

class CinemaCreate(BaseModel):
    name: str
    address: str

class ScreenCreate(BaseModel):
    cinema_id: int
    name: str
    total_seats: int = 50 

class ShowtimeCreate(BaseModel):
    movie_id: int
    screen_id: int
    start_time: datetime 
    base_price: float

class ShowtimeBatchCreate(BaseModel):
    movie_id: int
    screen_ids: List[int]
    start_time: datetime 
    base_price: float

class SeatTypeCreate(BaseModel):
    name: str
    surcharge_rate: float

class SeatBatchCreate(BaseModel):
    screen_id: int
    seat_type_id: int
    row_code: str
    start_number: int
    end_number: int

class SeatBatchUpdate(BaseModel):
    screen_id: int
    seat_type_id: int
    row_code: str
    start_number: int
    end_number: int
    is_active: bool
    
class ConcessionCreate(BaseModel):
    name: str
    price: float

# --- API ---

@app.get("/screens")
def get_all_screens(user=Depends(check_admin_role), db: Session = Depends(get_db)):
    screens = db.query(models.Screen).options(joinedload(models.Screen.cinema)).all()
    results = []
    for s in screens:
        results.append({
            "screen_id": s.screen_id,
            "name": s.name,
            "cinema_name": s.cinema.name,
            "total_seats": s.total_seats
        })
    return results

@app.get("/cinemas")
def get_all_cinemas(user=Depends(check_admin_role), db: Session = Depends(get_db)):
    return db.query(models.Cinema).all()

@app.post("/cinemas")
def add_cinema(c: CinemaCreate, user=Depends(check_admin_role), db: Session = Depends(get_db)):
    new_c = models.Cinema(name=c.name, address=c.address)
    db.add(new_c)
    db.commit()
    return {"status": "success", "message": f"Đã thêm rạp: {c.name}"}

@app.post("/screens")
def add_screen(s: ScreenCreate, user=Depends(check_admin_role), db: Session = Depends(get_db)):
    cinema = db.query(models.Cinema).filter(models.Cinema.cinema_id == s.cinema_id).first()
    if not cinema:
        raise HTTPException(status_code=404, detail="Rạp không tồn tại")
    new_s = models.Screen(cinema_id=s.cinema_id, name=s.name, total_seats=s.total_seats)
    db.add(new_s)
    db.commit()
    return {"status": "success", "message": f"Đã thêm phòng {s.name} vào rạp {cinema.name}"}

@app.post("/movies")
def add_movie(movie: MovieCreate, user=Depends(check_admin_role), db: Session = Depends(get_db)):
    new_movie = models.Movie(**movie.dict())
    db.add(new_movie)
    db.commit()
    return {"status": "success", "message": f"Đã thêm phim: {movie.title}"}

@app.put("/movies/{movie_id}/status")
def update_movie_status(movie_id: int, status_update: MovieStatusUpdate, user=Depends(check_admin_role), db: Session = Depends(get_db)):
    movie = db.query(models.Movie).filter(models.Movie.movie_id == movie_id).first()
    if not movie:
        raise HTTPException(status_code=404, detail="Movie not found")
    movie.status = status_update.status
    db.commit()
    return {"status": "success", "message": f"Đã cập nhật trạng thái thành {status_update.status}"}

@app.post("/showtimes")
def add_showtime(st: ShowtimeCreate, user=Depends(check_admin_role), db: Session = Depends(get_db)):
    new_st = models.Showtime(**st.dict())
    db.add(new_st)
    db.commit()
    return {"status": "success", "message": "Đã lên lịch chiếu thành công"}

@app.post("/showtimes/batch")
def add_showtime_batch(st: ShowtimeBatchCreate, user=Depends(check_admin_role), db: Session = Depends(get_db)):
    count = 0
    for screen_id in st.screen_ids:
        new_st = models.Showtime(
            movie_id=st.movie_id,
            screen_id=screen_id,
            start_time=st.start_time,
            base_price=st.base_price
        )
        db.add(new_st)
        count += 1
    db.commit()
    return {"status": "success", "message": f"Đã tạo {count} suất chiếu"}

# --- API GHẾ ---
@app.get("/seat-types")
def get_seat_types(user=Depends(check_admin_role), db: Session = Depends(get_db)):
    return db.query(models.SeatType).all()

@app.post("/seat-types")
def add_seat_type(st: SeatTypeCreate, user=Depends(check_admin_role), db: Session = Depends(get_db)):
    new_st = models.SeatType(name=st.name, surcharge_rate=st.surcharge_rate)
    db.add(new_st)
    db.commit()
    return {"status": "success", "message": f"Đã thêm loại ghế: {st.name}"}

@app.delete("/seat-types/{seat_type_id}")
def delete_seat_type(seat_type_id: int, user=Depends(check_admin_role), db: Session = Depends(get_db)):
    seat_type = db.query(models.SeatType).filter(models.SeatType.seat_type_id == seat_type_id).first()
    if not seat_type:
        raise HTTPException(status_code=404, detail="Loại ghế không tồn tại")

    seats_using_type = db.query(models.Seat).filter(models.Seat.seat_type_id == seat_type_id).count()
    if seats_using_type > 0:
        raise HTTPException(
            status_code=400,
            detail=f"Không thể xóa loại ghế này vì đang có {seats_using_type} ghế sử dụng.",
        )

    db.delete(seat_type)
    db.commit()
    return {"status": "success", "message": f"Đã xóa loại ghế: {seat_type.name}"}

@app.post("/seats/batch")
def add_seats_batch(batch: SeatBatchCreate, user=Depends(check_admin_role), db: Session = Depends(get_db)):
    count = 0
    for i in range(batch.start_number, batch.end_number + 1):
        exists = db.query(models.Seat).filter(
            models.Seat.screen_id == batch.screen_id,
            models.Seat.row_code == batch.row_code,
            models.Seat.seat_number == i
        ).first()
        
        if not exists:
            new_seat = models.Seat(
                screen_id=batch.screen_id,
                seat_type_id=batch.seat_type_id,
                row_code=batch.row_code,
                seat_number=i,
                is_active=True
            )
            db.add(new_seat)
            count += 1
            
    db.commit()
    return {"status": "success", "message": f"Đã thêm {count} ghế"}

@app.put("/seats/batch")
def update_seats_batch(batch: SeatBatchUpdate, user=Depends(check_admin_role), db: Session = Depends(get_db)):
    seats = db.query(models.Seat).filter(
        models.Seat.screen_id == batch.screen_id,
        models.Seat.row_code == batch.row_code,
        models.Seat.seat_number >= batch.start_number,
        models.Seat.seat_number <= batch.end_number
    ).all()
    
    count = 0
    for seat in seats:
        seat.seat_type_id = batch.seat_type_id
        seat.is_active = batch.is_active 
        count += 1
        
    db.commit()
    
    if count == 0:
        raise HTTPException(status_code=404, detail="Không tìm thấy ghế trong khoảng này để cập nhật.")
        
    return {"status": "success", "message": f"Đã cập nhật {count} ghế hàng {batch.row_code}"}

@app.get("/screens/{screen_id}/seats")
def get_screen_seats(screen_id: int, user=Depends(check_admin_role), db: Session = Depends(get_db)):
    return db.query(models.Seat).filter(models.Seat.screen_id == screen_id).all()

# --- API BẮP NƯỚC ---
@app.get("/concessions")
def get_all_concessions(user=Depends(check_admin_role), db: Session = Depends(get_db)):
    return db.query(models.ConcessionItem).all()

@app.post("/concessions")
def add_concession(item: ConcessionCreate, user=Depends(check_admin_role), db: Session = Depends(get_db)):
    new_item = models.ConcessionItem(name=item.name, price=item.price)
    db.add(new_item)
    db.commit()
    return {"status": "success", "message": f"Đã thêm món: {item.name}"}

@app.delete("/concessions/{item_id}")
def delete_concession(item_id: int, user=Depends(check_admin_role), db: Session = Depends(get_db)):
    item = db.query(models.ConcessionItem).filter(models.ConcessionItem.item_id == item_id).first()
    if not item:
        raise HTTPException(status_code=404, detail="Món không tồn tại")
    db.delete(item)
    db.commit()
    return {"status": "success", "message": "Đã xóa món ăn"}

# --- BÁO CÁO DOANH THU ---
@app.get("/reports/revenue")
def get_revenue_report(user=Depends(check_admin_role), db: Session = Depends(get_db)):
    total_revenue = db.query(func.sum(models.Booking.total_amount))\
        .filter(models.Booking.status == "CONFIRMED").scalar() or 0

    total_bookings = db.query(models.Booking).filter(models.Booking.status == "CONFIRMED").count()

    revenue_by_movie = db.query(
        models.Movie.title, 
        func.sum(models.Booking.total_amount).label("revenue")
    ).join(models.Showtime, models.Movie.movie_id == models.Showtime.movie_id)\
     .join(models.Booking, models.Showtime.showtime_id == models.Booking.showtime_id)\
     .filter(models.Booking.status == "CONFIRMED")\
     .group_by(models.Movie.title)\
     .order_by(func.sum(models.Booking.total_amount).desc())\
     .all()

    revenue_by_cinema = db.query(
        models.Cinema.name,
        func.sum(models.Booking.total_amount).label("revenue")
    ).join(models.Screen, models.Cinema.cinema_id == models.Screen.cinema_id)\
     .join(models.Showtime, models.Screen.screen_id == models.Showtime.screen_id)\
     .join(models.Booking, models.Showtime.showtime_id == models.Booking.showtime_id)\
     .filter(models.Booking.status == "CONFIRMED")\
     .group_by(models.Cinema.name)\
     .order_by(func.sum(models.Booking.total_amount).desc())\
     .all()

    return {
        "total_revenue": float(total_revenue),
        "total_orders": total_bookings,
        "by_movie": [{"title": r[0], "revenue": float(r[1])} for r in revenue_by_movie],
        "by_cinema": [{"name": r[0], "revenue": float(r[1])} for r in revenue_by_cinema],
        "report_date": datetime.now()
    }
