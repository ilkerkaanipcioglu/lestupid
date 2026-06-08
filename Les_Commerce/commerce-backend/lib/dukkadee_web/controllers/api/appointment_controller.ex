defmodule DukkadeeWeb.Api.AppointmentController do
  use DukkadeeWeb, :controller

  alias Dukkadee.Appointments

  def create(conn, %{"appointment" => appointment_params}) do
    # Check for autonomous AI Agent header (Agent-Friendly Protocol)
    agent_key = get_req_header(conn, "x-autonomous-key") |> List.first()

    appointment_params =
      if agent_key do
        original_notes = appointment_params["notes"] || ""
        Map.put(appointment_params, "notes", "[Otonom Yapay Zeka Ajanı Rezervasyonu (Anahtar: #{agent_key})]\n#{original_notes}")
      else
        appointment_params
      end

    case Appointments.create_appointment(appointment_params) do
      {:ok, appointment} ->
        # Auto-confirm appointments booked by trusted AI agents instantly
        {:ok, appointment} =
          if agent_key do
            Appointments.confirm_appointment(appointment)
          else
            {:ok, appointment}
          end

        conn
        |> put_status(:created)
        |> render(:show, appointment: appointment)

      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> put_view(DukkadeeWeb.ChangesetJSON)
        |> render(:error, changeset: changeset)
    end
  end
end
