# defmodule AtomicWeb.ProgressBarLive do
#   use AtomicWeb, :live_view

#   @impl true
#   def mount(_params, _session, socket) do
#     if connected?(socket), do: send(self(), :tick)
#     {:ok, assign(socket, progress: 0)}
#   end

#   @impl true
#   def handle_info(:tick, socket) do
#     new_progress = min(socket.assigns.progress + 5, 100)

#     if new_progress < 100 do
#       Process.send_after(self(), :tick, 1000)
#     end

#     {:noreply, assign(socket, progress: new_progress)}
#   end

#   @impl true
#   def render(assigns) do
#     ~H"""
#     <div id="progress-bar" style="width: 100%; border: 1px solid #000;">
#       <div style={"width: #{assigns.progress}%; background-color: #4caf50; height: 30px;"}></div>
#     </div>
#     <p>Progress: <%= @progress %>%</p>
#     """
#   end
# end
