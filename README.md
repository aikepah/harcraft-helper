# Harcraft Helper

A Rails application for managing Dungeons & Dragons crafting components and recipes. This tool helps players track harvested components from monsters and manage their party's crafting inventory for creating magical items.

## What is Harcraft Helper?

Harcraft Helper is designed for D&D players and Dungeon Masters who want to keep track of monster-derived crafting components. In D&D, players can harvest components from defeated monsters to craft magical items, potions, and other equipment. This application provides:

- **Component Inventory Management**: Track components harvested from different monster types
- **Crafting Recipes**: View items that can be crafted from available components
- **Harvesting Information**: See required skills, DCs, and special properties for each component
- **Party Management**: Organize components by adventuring party
- **Import Tools**: Bulk import component and recipe data from CSV/JSON sources

The harvesting and crafting systems are based on [Heliana's Guide to Monster Hunting](https://loottavern.com/helianas-series/) and its comprehensive crafting system. The project exists to solve the problem of managing complex crafting systems in D&D campaigns, where players need to remember which monsters provide which components and how to combine them for crafting.

## AI Agent Testing

This project serves as a testbed for evaluating various AI coding agents and their capabilities in building real-world applications. The goal is to assess the strengths and weaknesses of different AI models when working on complex Rails applications with modern frontend technologies.

**Currently tested agents:**

- GPT-4.1
- GPT-4o
- Grok Code Fast 1

**Future plans:**

- Gemini 2.5
- Claude Sonnet 4
- GPT-5

Each agent contributes features and improvements, allowing for comparative analysis of their coding patterns, problem-solving approaches, and ability to maintain code quality across a full-stack application.

## Prerequisites

- Ruby 3.4.2 (see `.ruby-version`)
- SQLite 3.8.0 or later
- Node.js (for asset compilation)
- Rails 8.0.2

## Installation

1. **Clone the repository:**

   ```bash
   git clone <repository-url>
   cd harcraft-helper
   ```

2. **Install Ruby dependencies:**

   ```bash
   bundle install
   ```

3. **Install JavaScript dependencies:**

   ```bash
   bin/importmap pin --download
   ```

## Database Setup

1. **Create the database:**

   ```bash
   bin/rails db:create
   ```

2. **Run migrations:**

   ```bash
   bin/rails db:migrate
   ```

3. **Load seed data (optional):**

   ```bash
   bin/rails db:seed
   ```

## Data Import

The application includes import scripts to populate component and craftable item data:

1. **Import components from JSON:**

   ```bash
   bin/rails components:import_from_json
   ```

2. **Import craftable items from CSV:**

   ```bash
   bin/rails craftable_items:import_from_csv
   ```

   You can also specify a custom file path:

   ```bash
   bin/rails craftable_items:import_from_csv[lib/my-craftable-items.csv]
   ```

## Running the Application

### Development Server

Start the development server with live CSS reloading:

```bash
bin/dev
```

This uses Foreman to run both the Rails server and Tailwind CSS watcher simultaneously.

### Alternative: Manual Startup

If you prefer to run services separately:

1. **Start the Rails server:**

   ```bash
   bin/rails server
   ```

2. **In another terminal, start the CSS watcher:**

   ```bash
   bin/rails tailwindcss:watch
   ```

The application will be available at `http://localhost:3000`.

## Testing

Run the test suite:

```bash
bin/rails test
```

Run system tests only:

```bash
bin/rails test:system
```

## Project Structure

- `app/models/` - Data models (Component, CraftableItem, Party, etc.)
- `app/controllers/` - Rails controllers for managing parties and components
- `app/views/` - ERB templates with Hotwire/Stimulus integration
- `app/helpers/` - View helpers for harvesting skill mappings
- `lib/tasks/` - Rake tasks for data import
- `test/` - Test suite including system tests with Capybara

## Key Features

### Component Management

- Browse components by monster type and component type
- View harvesting requirements (DC, skills needed)
- See component properties (edible, volatile, notes)
- Filter and paginate through component lists

### Party Inventory

- Create adventuring parties
- Add harvested components to party inventory
- Track component quantities
- View craftable items based on available components

### Crafting System

- Browse craftable items and their recipes
- See required components and quantities
- View crafting DCs and requirements

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests for new functionality
5. Ensure all tests pass
6. Submit a pull request

## License

This project is open source. Please check the license file for details.
