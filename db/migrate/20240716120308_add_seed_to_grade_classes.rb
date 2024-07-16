class AddSeedToGradeClasses < ActiveRecord::Migration[6.1]
    def change
      add_column :grade_classes, :seed, :boolean, default: false
    end
end
