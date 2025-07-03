defmodule Atomic.Repo.Seeds.Feed do
  @moduledoc """
  Seeds the database with feed posts.
  """
  alias Atomic.Activities
  alias Atomic.Feed.Post
  alias Atomic.Organizations
  alias Atomic.Organizations.Organization
  alias Atomic.Repo

  @activity_titles [
    "🌌 Geek Night",
    "💻 Hack Night",
    "🚀 Hackathon",
    "🛠️ Workshop",
    "🎤 Palestra",
    "🤝 Meetup",
    "🌍 Conferência",
    "📚 Seminário",
    "🎓 Curso",
    "🏋️ Bootcamp",
    "📖 Sessão de Estudo"
  ]

  @announcement_titles [
    "📢 Atualização importante da comunidade estudantil!",
    "🚀 Novidades emocionantes para todos os estudantes!",
    "🔔 Um anúncio que não vais querer perder!",
    "💡 Mantém-te informado: aqui está o que está a acontecer!",
    "📅 Grandes mudanças a caminho!",
    "🎉 Uma mensagem especial para os nossos membros!",
    "🚨 Vamos falar: aviso importante para ti!",
    "📣 Grandes oportunidades esperam por ti – lê mais aqui!",
    "🌟 Aqui está o que precisas de saber!",
    "🏆 Atenção, estudantes: temos algo para partilhar!"
  ]

  def activity_description(organization, activity_title) do
    activity_paragraphs = [
      "O #{organization.name} preparou mais uma edição de #{activity_title}! Esta é uma excelente oportunidade para te juntares a uma comunidade dinâmica, explorando novas ideias e desenvolvendo as tuas habilidades num ambiente envolvente e colaborativo.",
      "Junta-te ao #{organization.name} na próxima #{activity_title}! Um evento pensado para todos os que querem aprender, partilhar conhecimento e conectar-se com outros entusiastas da área.",
      "O #{organization.name} convida-te para a #{activity_title}! Prepara-te para um momento repleto de aprendizagem, desafios estimulantes e oportunidades de networking num ambiente descontraído.",
      "A #{activity_title} organizada pelo #{organization.name} está quase a chegar! Uma experiência única onde podes desenvolver novas competências e conhecer pessoas com interesses semelhantes.",
      "Não percas a #{activity_title} promovida pelo #{organization.name}! Um evento pensado para criar um espaço de partilha, crescimento e inovação. Fica atento para mais detalhes e garante já a tua presença! 🚀",
      "O #{organization.name} traz-te a #{activity_title}, um evento onde a aprendizagem e a diversão andam de mãos dadas. Vem descobrir novas oportunidades e expandir os teus horizontes!",
      "Vem participar na #{activity_title} organizada pelo #{organization.name}! Um momento perfeito para trocares experiências, aprenderes algo novo e te conectares com a comunidade.",
      "A #{activity_title} do #{organization.name} é uma oportunidade imperdível para todos os interessados em explorar novas áreas e desafios. Não fiques de fora!",
      "O #{organization.name} preparou a #{activity_title} a pensar em ti! Participa neste evento e aproveita para desenvolver as tuas competências num ambiente dinâmico e inspirador.",
      "Se procuras uma experiência enriquecedora, a #{activity_title} promovida pelo #{organization.name} é o evento certo para ti. Marca já na tua agenda e junta-te a nós!"
    ]

    paragraph = Enum.random(activity_paragraphs)
  end

  def announcement_description(organization) do
    announcement_paragraphs = [
      "📢 O #{organization.name} tem novidades para ti! Fica atento, porque algo incrível está a caminho. Em breve revelamos mais detalhes!",
      "🚀 Atenção, comunidade! O #{organization.name} está a preparar algo especial. Não vais querer perder esta novidade!",
      "🔔 Tens acompanhado as novidades do #{organization.name}? Um anúncio importante será feito em breve. Fica ligado!",
      "💡 Algo empolgante está a acontecer no #{organization.name}! Mal podemos esperar para partilhar contigo. Fica atento às nossas redes!",
      "📅 O #{organization.name} tem um grande anúncio para fazer. Prepara-te para descobrir algo que vai fazer a diferença!",
      "🎉 Boas notícias a caminho! O #{organization.name} está prestes a lançar uma nova iniciativa. Descobre tudo em breve!",
      "🚨 O #{organization.name} tem uma surpresa reservada para ti! Mantém-te ligado para não perderes esta grande oportunidade.",
      "📣 Está quase! Em breve o #{organization.name} vai anunciar algo que não vais querer perder. Fica atento!",
      "🌟 A equipa do #{organization.name} tem trabalhado em algo muito especial para ti. O anúncio oficial está a chegar!",
      "🏆 Uma grande novidade do #{organization.name} está prestes a ser revelada. Garante que não perdes esta oportunidade única!"
    ]

    paragraph = Enum.random(announcement_paragraphs)
  end

  def run do
    seed_posts()
  end

  def seed_posts do
    case Repo.all(Post) do
      [] ->
        organizations = Repo.all(Organization)

        for i <- 1..200 do
          type = Enum.random([:activity, :announcement])

          case type do
            :activity -> seed_activity(Enum.random(organizations), i)
            :announcement -> seed_announcement(Enum.random(organizations))
          end
        end

      _ ->
        Mix.shell().error("Found posts, aborting seeding posts.")
    end
  end

  def seed_activity(organization, i) do
    location = %{
      name: Faker.Address.city(),
      url: Faker.Internet.url()
    }

    title = Enum.random(@activity_titles)

    %{
      title: title,
      description: activity_description(organization, title),
      start: build_start_date(i),
      finish: build_finish_date(i),
      location: %{name: Faker.Company.name(), address: Faker.Address.street_address()},
      maximum_entries: Enum.random(11..20),
      organization_id: organization.id,
      enrolled: Enum.random(0..10)
    }
    |> Activities.create_activity_with_post()
    |> case do
      {:error, changeset} -> Mix.shell().error("#{inspect(changeset)}")
      _ -> :ok
    end
  end

  def seed_announcement(organization) do
    %{
      title: Enum.random(@announcement_titles),
      description: announcement_description(organization),
      organization_id: organization.id
    }
    |> Organizations.create_announcement_with_post()
    |> case do
      {:error, changeset} -> Mix.shell().error("#{inspect(changeset)}")
      _ -> :ok
    end
  end

  defp build_start_date(i) do
    NaiveDateTime.utc_now()
    |> NaiveDateTime.add(i, :day)
    |> NaiveDateTime.truncate(:second)
  end

  defp build_finish_date(i) do
    NaiveDateTime.utc_now()
    |> NaiveDateTime.add(i, :day)
    |> NaiveDateTime.add(Enum.random(1..4), :hour)
    |> NaiveDateTime.truncate(:second)
  end
end

Atomic.Repo.Seeds.Feed.run()
