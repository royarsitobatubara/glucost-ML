import joblib
import numpy as np
import pandas as pd
import string
from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from schemas import DiabetesInput, HeartAttackInput, ObesitasInput, StressInput
import os

app = FastAPI()

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=False,
    allow_methods=["*"],
    allow_headers=["*"],
)

model_dir = "model"

modelDiabetes = joblib.load(os.path.join(model_dir, "diabetes_rf_model.pkl"))
modelObesitas = joblib.load(os.path.join(model_dir, "obesity_rf_model.pkl"))
modelStress = joblib.load(os.path.join(model_dir, "stress_rf_model.pkl"))
heart_attack_data = joblib.load(os.path.join(model_dir, "heart_attack_model.pkl"))

# 2. LOAD HEART ATTACK (Model + Imputer dipisahkan dari dictionary .pkl)
modelHeartAttack = heart_attack_data["model"]  # Ambil modelnya
imputerHeartAttack = heart_attack_data["imputer"]  # Ambil imputernya 👈

classes = modelObesitas.named_steps["rf"].classes_


@app.post("/predict/diabetes")
def predict_diabetes(data: DiabetesInput):
    df = pd.DataFrame(
        [
            {
                "Pregnancies": data.Pregnancies,
                "Glucose": data.Glucose,
                "BloodPressure": data.BloodPressure,
                "SkinThickness": data.SkinThickness,
                "Insulin": data.Insulin,
                "BMI": data.BMI,
                "DiabetesPedigreeFunction": data.DiabetesPedigreeFunction,
                "Age": data.Age,
            }
        ]
    )
    hasil = modelDiabetes.predict(df)[0]
    prob = modelDiabetes.predict_proba(df)[0]
    return {
        "prediction": int(hasil),
        "status": "Diabetes" if hasil == 1 else "Tidak Diabetes",
        "probability_diabetes": round(prob[1] * 100, 2),
        "probability_non_diabetes": round(prob[0] * 100, 2),
    }


@app.post("/predict/obesitas")
def predict_obesitas(data: ObesitasInput):
    mtrans_hasil = string.capwords(str(data.MTRANS)).replace(" ", "_")
    df = pd.DataFrame(
        [
            {
                "Gender": data.Gender.capitalize(),
                "Age": data.Age,
                "Height": data.Height,
                "Weight": data.Weight,
                "family_history": data.family_history.lower(),
                "FAVC": data.FAVC.lower(),
                "FCVC": data.FCVC,
                "NCP": data.NCP,
                "CAEC": data.CAEC.capitalize(),
                "SMOKE": data.SMOKE.lower(),
                "CH2O": data.CH2O,
                "SCC": data.SCC.lower(),
                "FAF": data.FAF,
                "TUE": data.TUE,
                "CALC": data.CALC.capitalize(),
                "MTRANS": mtrans_hasil,
            }
        ]
    )

    hasil_klasifikasi = modelObesitas.predict(df)[0]
    probabilitas = modelObesitas.predict_proba(df)[0]
    index_tertinggi = np.argmax(probabilitas)
    persentase_keyakinan = probabilitas[index_tertinggi] * 100

    # DISESUAIKAN: Output berupa float angka murni dan struktur flat
    detail_probabilitas = {
        f"{str(kelas).lower().replace(' ', '_')}_probability": round(float(prob) * 100, 2)
        for kelas, prob in zip(classes, probabilitas)
    }

    response = {
        "result": str(hasil_klasifikasi).replace("_", " "),
        "confidence_score": round(persentase_keyakinan, 2),
    }
    response.update(detail_probabilitas)
    
    return response


@app.post("/predict/heart_attack")
def predict_heart_attack(data: HeartAttackInput):
    # 1. Tampung input dari request ke dictionary
    input_dict = {
        "gender": data.gender,
        "age": data.age,
        "body_mass_index": data.body_mass_index if data.body_mass_index is not None else np.nan,
        "smoker": data.smoker,
        "systolic_blood_pressure": data.systolic_blood_pressure if data.systolic_blood_pressure is not None else np.nan,
        "hypertension_treated": data.hypertension_treated,
        "family_history_of_cardiovascular_disease": data.family_history_of_cardiovascular_disease,
        "atrial_fibrillation": data.atrial_fibrillation,
        "chronic_kidney_disease": data.chronic_kidney_disease,
        "rheumatoid_arthritis": data.rheumatoid_arthritis,
        "diabetes": data.diabetes,
        "chronic_obstructive_pulmonary_disorder": data.chronic_obstructive_pulmonary_disorder,
        "forced_expiratory_volume_1": data.forced_expiratory_volume_1 if data.forced_expiratory_volume_1 is not None else np.nan,
    }

    # 2. URUTAN KOLOM WAJIB SAMA PERSIS DENGAN FITUR X SAAT TRAINING
    # Jangan sampai ada yang tertukar posisi indeksnya
    kolom_urut = [
        "gender",
        "age",
        "body_mass_index",
        "smoker",
        "systolic_blood_pressure",
        "hypertension_treated",
        "family_history_of_cardiovascular_disease",
        "atrial_fibrillation",
        "chronic_kidney_disease",
        "rheumatoid_arthritis",
        "diabetes",
        "chronic_obstructive_pulmonary_disorder",
        "forced_expiratory_volume_1"
    ]
    df = pd.DataFrame([input_dict])[kolom_urut]

    # 3. Jalankan Imputer bawaan model pkl
    df_imputed = imputerHeartAttack.transform(df)  
    df_ready = pd.DataFrame(df_imputed, columns=df.columns)

    # 4. Lakukan Prediksi
    prediksi = modelHeartAttack.predict(df_ready)[0]
    probabilitas = modelHeartAttack.predict_proba(df_ready)[0]
    
    return {
        "is_risk": int(prediksi),
        "risk_percentage": round(float(probabilitas[1] * 100), 2),
        "safe_percentage": round(float(probabilitas[0] * 100), 2),
        "message": "Berisiko Serangan Jantung" if prediksi == 1 else "Aman / Risiko Rendah",
    }


@app.post("/predict/stress")
def predict_stress(data: StressInput):
    df = pd.DataFrame([
        {
            "Humidity": data.Humidity,
            "Temperature": data.Temperature,
            "Step count": data.Step_count
        }
    ])
    hasil = modelStress.predict(df)[0]
    probabilitas = modelStress.predict_proba(df)[0]
    index_tertinggi = np.argmax(probabilitas)
    persentase_keyakinan = probabilitas[index_tertinggi] * 100    
    
    # Ganti format ke float (tanpa tanda % di dalam string)
    detail_probabilitas = {
        f"class_{i}_probability": round(float(prob) * 100, 2) for i, prob in enumerate(probabilitas)
    }    
    
    response = {
        "prediction": int(hasil) if isinstance(hasil, (int, np.integer)) else str(hasil),
        "confidence_score": round(persentase_keyakinan, 2),
    }
    
    # Menggabungkan dictionary secara flat (tidak bersarang)
    response.update(detail_probabilitas)
    response["message"] = "Prediksi stress berhasil."    
    
    return response