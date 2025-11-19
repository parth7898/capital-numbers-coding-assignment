#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

echo " Starting project setup..."

# 1 Install Ruby gems
echo " Installing Ruby gems..."
bundle install

# 2 Setup database
echo "  Setting up database..."
rails db:create
rails db:migrate

# 3 Seed database
echo " Seeding database..."
rails db:seed

# 4️ Precompile assets (optional for dev)
echo " Precompiling assets..."
rails assets:precompile

# 5️ Done
echo " Project setup complete!"
echo "You can now run 'rails server' to start the app."
