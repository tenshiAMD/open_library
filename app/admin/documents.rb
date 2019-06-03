ActiveAdmin.register Document do
  permit_params :title, :source, :file_source, :url

  index do
    selectable_column
    id_column
    column :title
    column :source
    column :url
    column :created_at
    column :updated_at
    actions
  end

  filter :title
  filter :source
  filter :url
  filter :created_at
  filter :updated_at

  form partial: '/activeadmin/documents/form'

  show do
    attributes_table do
      row :title
      row :source
      row :url
      row :created_at
      row :updated_at
      row :file_source do |document|
        image_tag document.file_source.preview(resize: "700x400")
      end
    end
  end
end
