# server/schemas.py
from pydantic import BaseModel

class DiabetesInput(BaseModel):
    Pregnancies: int
    Glucose: float
    BloodPressure: float
    SkinThickness: float
    Insulin: float
    BMI: float
    DiabetesPedigreeFunction: float
    Age: int

class ObesitasInput(BaseModel):
    Gender: str
    Age: int
    Height: float
    Weight: float
    family_history: str
    FAVC: str
    FCVC: float
    NCP: float
    CAEC: str
    SMOKE: str
    CH2O: float
    SCC: str
    FAF: float
    TUE: float
    CALC: str
    MTRANS: str

class HeartAttackInput(BaseModel) :
    gender: int 
    age: int
    body_mass_index: float
    smoker: int
    systolic_blood_pressure: float
    hypertension_treated: int
    family_history_of_cardiovascular_disease: int
    atrial_fibrillation: int
    chronic_kidney_disease: int
    rheumatoid_arthritis: int
    diabetes: int
    chronic_obstructive_pulmonary_disorder: int
    forced_expiratory_volume_1: float

class StressInput(BaseModel):
    Humidity: float
    Temperature: float
    Step_count: int