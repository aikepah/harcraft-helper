module ApplicationHelper
  # Mapping of monster types to assessment skills (Intelligence-based)
  ASSESSMENT_SKILLS = {
    "Aberration" => "Arcana",
    "Beast" => "Survival",
    "Celestial" => "Religion",
    "Construct" => "Investigation",
    "Dragon" => "Survival",
    "Elemental" => "Arcana",
    "Fey" => "Arcana",
    "Fiend" => "Religion",
    "Giant" => "Medicine",
    "Humanoid" => "Medicine",
    "Monstrosity" => "Survival",
    "Ooze" => "Nature",
    "Plant" => "Nature",
    "Undead" => "Medicine"
  }.freeze

  # Creature types that allow Ritual Carving (spellcasting ability instead of Dexterity)
  RITUAL_CARVING_TYPES = %w[Aberration Celestial Elemental Fey Fiend].freeze

  def assessment_skill_for_monster_type(monster_type)
    ASSESSMENT_SKILLS[monster_type&.titleize] || "Unknown"
  end

  def ritual_carving_allowed?(monster_type)
    RITUAL_CARVING_TYPES.include?(monster_type&.titleize)
  end

  def harvesting_info_for_component(component)
    monster_type = component.monster_type&.titleize
    skill = assessment_skill_for_monster_type(monster_type)
    ritual_allowed = ritual_carving_allowed?(monster_type)

    {
      assessment_skill: skill,
      ritual_carving_allowed: ritual_allowed
    }
  end
end
