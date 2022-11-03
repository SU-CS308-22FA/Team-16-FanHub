import * as firebase from "firebase";
import "firebase/database";

let config = {
  apiKey: "AIzaSyDGYeYSUsRRwELkQ32C3V6XZLnY15WLpoQ",
    authDomain: "fanhub-737e5.firebaseapp.com",
    projectId: "fanhub-737e5",
    storageBucket: "fanhub-737e5.appspot.com",
    messagingSenderId: "1079192395576",
    appId: "1:1079192395576:web:e1bde50a00918dbe5f2bcd",
    measurementId: "G-NVQTY28HJR",
    databaseURL: "https://fanhub-737e5-default-rtdb.europe-west1.firebasedatabase.app/"
};

firebase.initializeApp(config);
export default firebase.database();
