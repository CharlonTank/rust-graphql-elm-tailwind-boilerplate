use bcrypt::{hash, DEFAULT_COST};

fn main() {
    let passwords = vec!["test123", "admin123"];
    
    for password in passwords {
        let hashed = hash(password, DEFAULT_COST).unwrap();
        println!("Password '{}' hash: {}", password, hashed);
    }
} 