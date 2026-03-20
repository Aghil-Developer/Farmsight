from flask import Flask, request, jsonify
import tensorflow as tf
import numpy as np
import pickle
from io import BytesIO
import pandas as pd
import os

app = Flask(__name__)


disease_model = tf.keras.models.load_model("trained_model.h5")
dtr = pickle.load(open("dtr.pkl", "rb"))
preprocessor = pickle.load(open("preprocessor.pkl", "rb"))


class_name = [
"Apple___Apple_scab","Apple___Black_rot","Apple___Cedar_apple_rust","Apple___healthy",
"Blueberry___healthy","Cherry_(including_sour)___Powdery_mildew","Cherry_(including_sour)___healthy",
"Corn_(maize)___Cercospora_leaf_spot Gray_leaf_spot","Corn_(maize)___Common_rust",
"Corn_(maize)___Northern_Leaf_Blight","Corn_(maize)___healthy","Grape___Black_rot",
"Grape___Esca_(Black_Measles)","Grape___Leaf_blight_(Isariopsis_Leaf_Spot)","Grape___healthy",
"Orange___Haunglongbing_(Citrus_greening)","Peach___Bacterial_spot","Peach___healthy",
"Pepper_bell___Bacterial_spot","Pepper_bell___healthy","Potato___Early_blight",
"Potato___Late_blight","Potato___healthy","Raspberry___healthy","Soybean___healthy",
"Squash___Powdery_mildew","Strawberry___Leaf_scorch","Strawberry___healthy","Tomato___Bacterial_spot",
"Tomato___Early_blight","Tomato___Late_blight","Tomato___Leaf_Mold","Tomato___Septoria_leaf_spot",
"Tomato___Spider_mites Two-spotted_spider_mite","Tomato___Target_Spot",
"Tomato___Tomato_Yellow_Leaf_Curl_Virus","Tomato___Tomato_mosaic_virus","Tomato___healthy"
]


treatment_db = {

"Apple_scab":{
"pesticide":"Captan fungicide",
"fertilizer":"Balanced NPK fertilizer",
"advice":"Prune infected leaves and maintain good air circulation"
},

"Black_rot":{
"pesticide":"Myclobutanil fungicide",
"fertilizer":"Potassium rich fertilizer",
"advice":"Remove infected fruits and leaves from orchard"
},

"Cedar_apple_rust":{
"pesticide":"Sulfur fungicide",
"fertilizer":"Balanced NPK fertilizer",
"advice":"Remove nearby cedar hosts and prune infected leaves"
},

"Powdery_mildew":{
"pesticide":"Sulfur fungicide spray",
"fertilizer":"Nitrogen balanced fertilizer",
"advice":"Improve air circulation and avoid overcrowding plants"
},

"Cercospora_leaf_spot Gray_leaf_spot":{
"pesticide":"Azoxystrobin fungicide",
"fertilizer":"Nitrogen fertilizer",
"advice":"Rotate crops and remove infected plant debris"
},

"Common_rust":{
"pesticide":"Propiconazole fungicide",
"fertilizer":"Balanced NPK fertilizer",
"advice":"Plant resistant varieties and monitor fields regularly"
},

"Northern_Leaf_Blight":{
"pesticide":"Mancozeb fungicide",
"fertilizer":"Nitrogen fertilizer",
"advice":"Practice crop rotation and remove infected leaves"
},

"Esca_(Black_Measles)":{
"pesticide":"Thiophanate methyl fungicide",
"fertilizer":"Balanced fertilizer",
"advice":"Prune infected vines and disinfect tools"
},

"Leaf_blight_(Isariopsis_Leaf_Spot)":{
"pesticide":"Copper fungicide",
"fertilizer":"Potassium fertilizer",
"advice":"Ensure proper drainage and remove infected leaves"
},

"Haunglongbing_(Citrus_greening)":{
"pesticide":"Imidacloprid insecticide",
"fertilizer":"Micronutrient fertilizer",
"advice":"Control psyllid insects and remove infected trees"
},

"Bacterial_spot":{
"pesticide":"Copper bactericide",
"fertilizer":"Potassium fertilizer",
"advice":"Avoid overhead irrigation and remove infected leaves"
},

"Early_blight":{
"pesticide":"Chlorothalonil fungicide",
"fertilizer":"Nitrogen rich fertilizer",
"advice":"Remove infected leaves and avoid wet foliage"
},

"Late_blight":{
"pesticide":"Mancozeb fungicide",
"fertilizer":"Potassium rich fertilizer",
"advice":"Ensure good drainage and avoid excessive moisture"
},

"Leaf_Mold":{
"pesticide":"Copper fungicide",
"fertilizer":"Balanced NPK fertilizer",
"advice":"Increase air circulation and reduce humidity"
},

"Septoria_leaf_spot":{
"pesticide":"Chlorothalonil fungicide",
"fertilizer":"Nitrogen fertilizer",
"advice":"Remove infected leaves and maintain plant spacing"
},

"Spider_mites Two-spotted_spider_mite":{
"pesticide":"Neem oil or Abamectin spray",
"fertilizer":"Balanced NPK fertilizer",
"advice":"Increase humidity and spray neem oil weekly"
},

"Target_Spot":{
"pesticide":"Chlorothalonil fungicide",
"fertilizer":"Balanced fertilizer",
"advice":"Remove infected leaves and maintain airflow"
},

"Tomato_Yellow_Leaf_Curl_Virus":{
"pesticide":"Imidacloprid (for whitefly control)",
"fertilizer":"Micronutrient fertilizer",
"advice":"Use resistant varieties and control whiteflies"
},

"Tomato_mosaic_virus":{
"pesticide":"No chemical control",
"fertilizer":"Balanced NPK fertilizer",
"advice":"Remove infected plants and disinfect tools"
},

"Leaf_scorch":{
"pesticide":"Copper fungicide",
"fertilizer":"Potassium fertilizer",
"advice":"Maintain proper irrigation and remove infected leaves"
}

}




def predict_disease(image_file):

    image = tf.keras.preprocessing.image.load_img(image_file, target_size=(128,128))
    input_arr = tf.keras.preprocessing.image.img_to_array(image)
    input_arr = np.expand_dims(input_arr, axis=0)

    prediction = disease_model.predict(input_arr)
    result_index = np.argmax(prediction)
    predicted_class = class_name[result_index]

    if "healthy" in predicted_class.lower():
        status = "Healthy"
        disease = None
    else:
        status = "Diseased"
        disease = predicted_class.split("___")[-1].replace("_"," ")

    return {
        "predicted_class": predicted_class,
        "status": status,
        "disease": disease
    }



def get_treatment(predicted_class):

    disease_name = predicted_class.split("___")[-1]

    if disease_name in treatment_db:
        return treatment_db[disease_name]

    return {
        "pesticide":"Consult agriculture expert",
        "fertilizer":"Balanced NPK fertilizer",
        "advice":"Monitor crop condition"
    }



def predict_yield(features):

    cols = [
    "Year",
    "average_rain_fall_mm_per_year",
    "pesticides_tonnes",
    "avg_temp",
    "Area",
    "Item"
    ]

    df = pd.DataFrame([features], columns=cols)

    transformed_features = preprocessor.transform(df)
    prediction = dtr.predict(transformed_features)

    return float(prediction[0])



@app.route("/", methods=["GET"])
def index():
    return "AgriFly Crop Yield + Disease Prediction API Running"


@app.route("/predict_disease", methods=["POST"])
def disease_endpoint():

    if "file" not in request.files:
        return jsonify({"error":"No file uploaded"}),400

    file = request.files["file"]
    img = BytesIO(file.read())

    result = predict_disease(img)
    treatment = get_treatment(result["predicted_class"])

    response = {
        "predicted_class": result["predicted_class"],
        "status": result["status"],
        "disease": result["disease"],
        "recommended_pesticide": treatment["pesticide"],
        "recommended_fertilizer": treatment["fertilizer"],
        "advice": treatment["advice"]
    }

    return jsonify(response)


@app.route("/predict_yield", methods=["POST"])
def yield_endpoint():

    data = request.json

    try:

        features = [
        data["Year"],
        data["average_rain_fall_mm_per_year"],
        data["pesticides_tonnes"],
        data["avg_temp"],
        data["Area"],
        data["Item"]
        ]

        predicted_yield = predict_yield(features)

        return jsonify({"predicted_yield": predicted_yield})

    except Exception as e:
        return jsonify({"error": str(e)}),400



if __name__ == "__main__":

    os.environ["TF_CPP_MIN_LOG_LEVEL"] = "2"

    app.run(host="0.0.0.0", port=5000, debug=True)