use juniper::FieldResult;
use crate::graphql::schema::Context;
use super::types::User;

pub struct UserQueries;

#[juniper::graphql_object(Context = Context)]
impl UserQueries {
    pub fn users(context: &Context) -> FieldResult<Vec<User>> {
        let users = context.users.lock().unwrap();
        Ok(users.values().cloned().collect())
    }
} 