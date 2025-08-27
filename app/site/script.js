document.getElementById('btn').addEventListener('click', () => {
  const t = new Date().toLocaleString();
  document.getElementById('out').textContent = `Button clicked at ${t}`;
});