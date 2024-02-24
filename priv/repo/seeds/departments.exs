defmodule Atomic.Repo.Seeds.Departments do
  @moduledoc """
  Seeds the database with departments.
  """
  alias Atomic.Departments
  alias Atomic.Organizations.{Department, Organization}
  alias Atomic.Repo

  @departments [
    {"CAOS",
     "O CAOS (Centro de Apoio ao Open-Source) é o departamento responsável por todo o desenvolvimento de software associado ao CeSIUM, quer sejam as plataformas que servem diretamente o núcleo e os seus eventos, ou as plataformas úteis para os alunos. Durante o processo, procura expandir o conhecimento dos seus colaboradores, para além daquilo que aprendem no curso. 💻"},
    {"Marketing e Conteúdo",
     "O Departamento de Marketing e Conteúdo é responsável por promover todas as atividades efetuadas pelo núcleo, manter toda a identidade visual do CeSIUM e efetuar a comunicação através das nossas redes sociais. 💡"},
    {"Recreativo",
     "O Departamento Recreativo é o responsável por organizar atividades de cariz cultural e/ou lúdico, com o intuito de promover a relação entre os vários estudantes, professores e funcionários. 🤪"},
    {"Pedagógico",
     "O Departamento Pedagógico é o responsável por promover a relação entre a Direção de Curso e os alunos do LEI/MEI/MIEI e, ainda, por organizar atividades que complementam a formação académica dos mesmos. ✏️"},
    {"Relações Externas e Merch",
     "O Departamento de Relações Externas e Merch é responsável por todo o merchandising do núcleo e por manter e fechar parceriais com diversas entidades e negócios, das quais os sócios do CeSIUM, assim como o núcleo, possam tirar proveito. 🤝"},
    {"Financeiro",
     "O Departamento Financeiro é o responsável por toda a gestão financeira do núcleo, desde a organização de contas, ao controlo de despesas e receitas. 💰"},
    {"Administrativo",
     "O Departamento Administrativo é o responsável por toda a gestão administrativa do núcleo, desde a organização de documentos, ao controlo de processos e procedimentos. 📝"}
  ]

  def run do
    case Repo.all(Department) do
      [] ->
        seed_departments()
        seed_collaborators()

      _ ->
        Mix.shell().error("Found departments, aborting seeding departments.")
    end
  end

  def seed_departments do
    organizations = Repo.all(Organization)

    for organization <- organizations do
      for i <- 0..Enum.random(4..(length(@departments) - 1)) do
        case @departments |> Enum.at(i) do
          {name, description} ->
            %{
              name: name,
              description: description,
              organization_id: organization.id
            }
            |> Departments.create_department()
        end
      end
    end
  end

  def seed_collaborators() do
    for department <- Repo.all(Department) do
      for user <- Repo.all(Atomic.Accounts.User) do
        if Enum.random(0..6) == 1 do
          %{
            department_id: department.id,
            user_id: user.id
          }
          |> Departments.create_collaborator()
        end
      end
    end
  end
end

Atomic.Repo.Seeds.Departments.run()
