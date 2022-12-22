use actix_web::{web, HttpResponse};

pub async fn subscribe(_form: web::Form<FormData>) -> HttpResponse {
    HttpResponse::Ok().finish()
}

#[derive(serde::Deserialize)]
#[allow(dead_code)]
pub struct FormData {
    email: String,
    name: String,
}
