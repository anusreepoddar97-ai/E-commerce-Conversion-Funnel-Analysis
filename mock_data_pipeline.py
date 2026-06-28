import pandas as pd
import random
from faker import Faker
from datetime import timedelta

# Initialize Faker to generate realistic dummy dates
fake = Faker()

# 1. Define Products (Matches exactly with your Tableau dashboard)
products_data = [
    {"Product Id": "P001", "Product Name": "Smart Watch", "Category": "Electronics", "Price": 250.0},
    {"Product Id": "P002", "Product Name": "Wireless Headphones", "Category": "Electronics", "Price": 150.0},
    {"Product Id": "P003", "Product Name": "Running Shoes", "Category": "Apparel", "Price": 120.0},
    {"Product Id": "P004", "Product Name": "Mechanical Keyboard", "Category": "Electronics", "Price": 85.0},
    {"Product Id": "P005", "Product Name": "Yoga Mat", "Category": "Fitness", "Price": 35.0}
]
products_df = pd.DataFrame(products_data)

# 2. Generate Users
NUM_USERS = 1000
devices = ["Desktop", "Mobile", "Tablet"]
device_weights = [0.30, 0.60, 0.10] 

users_data = []
for i in range(NUM_USERS):
    users_data.append({
        "User Id": f"U{i:04d}",
        "Device Type": random.choices(devices, weights=device_weights)[0],
        "Signup Date": fake.date_between(start_date='-1y', end_date='today')
    })
users_df = pd.DataFrame(users_data)

# 3. Generate Events (Funnel Simulation)
events_data = []
event_id_counter = 1

for user in users_data:
    # Each user interacts with 1 to 3 random products
    num_products_viewed = random.randint(1, 3)
    viewed_products = random.sample(products_data, num_products_viewed)
    
    for product in viewed_products:
        # Base timestamp for the interaction
        current_time = fake.date_time_between(start_date=user["Signup Date"], end_date='now')
        
        # Step 1: Page View (100% chance if they interact with the product)
        events_data.append({
            "Event Id": f"E{event_id_counter:05d}",
            "User Id": user["User Id"],
            "Product Id": product["Product Id"],
            "Event Type": "page_view",
            "Event Time": current_time
        })
        event_id_counter += 1
        
        # Step 2: Add to Cart (~60% chance to proceed)
        if random.random() <= 0.60:
            current_time += timedelta(minutes=random.randint(1, 10))
            events_data.append({
                "Event Id": f"E{event_id_counter:05d}",
                "User Id": user["User Id"],
                "Product Id": product["Product Id"],
                "Event Type": "add_to_cart",
                "Event Time": current_time
            })
            event_id_counter += 1
            
            # Step 3: Checkout (~52% chance to proceed from cart)
            if random.random() <= 0.52:
                current_time += timedelta(minutes=random.randint(1, 5))
                events_data.append({
                    "Event Id": f"E{event_id_counter:05d}",
                    "User Id": user["User Id"],
                    "Product Id": product["Product Id"],
                    "Event Type": "checkout",
                    "Event Time": current_time
                })
                event_id_counter += 1
                
                # Step 4: Purchase (~68% chance to proceed from checkout)
                if random.random() <= 0.68:
                    current_time += timedelta(minutes=random.randint(1, 3))
                    events_data.append({
                        "Event Id": f"E{event_id_counter:05d}",
                        "User Id": user["User Id"],
                        "Product Id": product["Product Id"],
                        "Event Type": "purchase",
                        "Event Time": current_time
                    })
                    event_id_counter += 1

events_df = pd.DataFrame(events_data)

# 4. Export to CSV
users_df.to_csv("users.csv", index=False)
products_df.to_csv("products.csv", index=False)
events_df.to_csv("events.csv", index=False)

print(f"Pipeline Complete: Generated {len(users_df)} users, {len(products_df)} products, and {len(events_df)} funnel events.")
print("Saved outputs as users.csv, products.csv, and events.csv.")
