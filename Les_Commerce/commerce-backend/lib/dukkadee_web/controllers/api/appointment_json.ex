defmodule DukkadeeWeb.Api.AppointmentJSON do
  alias Dukkadee.Appointments.Appointment

  def show(%{appointment: appointment}) do
    %{data: data(appointment)}
  end

  def data(%Appointment{} = appointment) do
    # Generate Schema.org Reservation JSON-LD for usta appointments
    json_ld = %{
      "@context" => "https://schema.org",
      "@type" => "Reservation",
      "reservationNumber" => to_string(appointment.id),
      "reservationStatus" => "https://schema.org/Confirmed",
      "underName" => %{
        "@type" => "Person",
        "name" => appointment.customer_name,
        "email" => appointment.customer_email
      },
      "bookingTime" => appointment.inserted_at,
      "startDate" => appointment.start_time,
      "endDate" => appointment.end_time
    }

    %{
      id: appointment.id,
      start_time: appointment.start_time,
      end_time: appointment.end_time,
      customer_name: appointment.customer_name,
      customer_email: appointment.customer_email,
      customer_phone: appointment.customer_phone,
      status: appointment.status,
      notes: appointment.notes,
      product_id: appointment.product_id,
      schema_metadata: json_ld
    }
  end
end
