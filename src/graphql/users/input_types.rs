use juniper::GraphQLInputObject;

#[derive(GraphQLInputObject)]
pub struct SignupInput {
    pub username: String,
    pub password: String,
}

#[derive(GraphQLInputObject)]
pub struct LoginInput {
    pub username: String,
    pub password: String,
}

#[derive(GraphQLInputObject)]
pub struct AdminLoginInput {
    pub password: String,
} 