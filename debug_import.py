print("Importing main...")
import app.main
print("Main imported successfully.")

print("Importing analytics...")
import app.api.analytics
print("Analytics imported successfully.")

print("Importing metrics...")
import app.api.metrics
print("Metrics imported successfully.")

print("Importing DB session...")
import app.db.session
print("DB session imported successfully.")

print("All imports OK.")
