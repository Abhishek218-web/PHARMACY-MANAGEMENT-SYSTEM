
const medicines = [
    {id: 101, name: "Paracetamol", price: 2.50, stock: 100, expiry: "2027-12-31"},
    {id: 102, name: "Amoxicillin", price: 5.00, stock: 50, expiry: "2027-06-30"},
    {id: 103, name: "Cough Syrup", price: 80.00, stock: 8, expiry: "2027-01-15"},
    {id: 104, name: "Vitamin C", price: 3.00, stock: 30, expiry: "2028-03-31"}
];

function isExpired(medicine) {
    return medicine.expiry < new Date().toISOString().slice(0, 10);
}

function getStatus(medicine) {
    if (isExpired(medicine)) {
        return '<span class="status danger">Expired</span>';
    }

    if (medicine.stock < 10) {
        return '<span class="status warning">Low Stock</span>';
    }

    return '<span class="status good">In Stock</span>';
}

function renderMedicines() {
    const search = document.getElementById("searchInput")
        .value.toLowerCase();

    const filtered = medicines.filter(m =>
        m.name.toLowerCase().includes(search) ||
        String(m.id).includes(search)
    );

    document.getElementById("medicineTable").innerHTML =
        filtered.map(m => `
            <tr>
                <td>${m.id}</td>
                <td>${m.name}</td>
                <td>₹${m.price.toFixed(2)}</td>
                <td>${m.stock}</td>
                <td>${m.expiry}</td>
                <td>${getStatus(m)}</td>
            </tr>
        `).join("");
}

function updateDashboard() {
    document.getElementById("totalMedicines").textContent =
        medicines.length;

    document.getElementById("totalStock").textContent =
        medicines.reduce((sum, m) => sum + m.stock, 0);

    document.getElementById("lowStock").textContent =
        medicines.filter(m => m.stock < 10 && !isExpired(m)).length;

    document.getElementById("expiredStock").textContent =
        medicines.filter(isExpired).length;

    const alerts = medicines.filter(m =>
        isExpired(m) || m.stock < 10
    );

    document.getElementById("alertList").innerHTML =
        alerts.length
            ? alerts.map(m =>
                `<p>${isExpired(m) ? "🔴" : "🟠"} <strong>${m.name}</strong> — ${
                    isExpired(m) ? "Expired medicine" : "Only " + m.stock + " units left"
                }</p>`
              ).join("")
            : "<p>No stock alerts.</p>";

    document.getElementById("medicineId").innerHTML =
        medicines.filter(m => !isExpired(m) && m.stock > 0)
        .map(m =>
            `<option value="${m.id}">${m.name} — ₹${m.price.toFixed(2)}</option>`
        ).join("");
}

document.getElementById("saleForm").addEventListener("submit", function(event) {
    event.preventDefault();

    const id = Number(document.getElementById("medicineId").value);
    const quantity = Number(document.getElementById("quantity").value);
    const medicine = medicines.find(m => m.id === id);
    const message = document.getElementById("saleMessage");

    if (!medicine || !Number.isInteger(quantity) || quantity <= 0) {
        message.textContent = "Enter a valid medicine and quantity.";
        return;
    }

    if (isExpired(medicine)) {
        message.textContent = "Sale rejected: this medicine has expired.";
        return;
    }

    if (quantity > medicine.stock) {
        message.textContent = "Sale rejected: insufficient stock.";
        return;
    }

    const total = medicine.price * quantity;
    medicine.stock -= quantity;

    message.textContent =
        `Demo sale successful! Total bill: ₹${total.toFixed(2)}. Remaining stock: ${medicine.stock}.`;

    document.getElementById("quantity").value = "";
    renderMedicines();
    updateDashboard();
});

renderMedicines();
updateDashboard();
