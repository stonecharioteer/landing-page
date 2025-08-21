---
title: "Swimming Journey"
description: "My progress learning to swim, overcoming submechanophobia and building endurance"
date: 2023-02-01T00:00:00Z
url: "/swimming-journey/"
---

This page tracks my journey learning to swim, starting in February 2023.

## Progress Overview

From being terrified to get past the 15m mark to swimming 700m in sessions - here's my measurable progress:

<div id="swimming-progress">
<table id="progress-table">
<thead>
<tr>
<th>Date</th>
<th>Distance Per Session</th>
<th>Details</th>
</tr>
</thead>
<tbody id="progress-data">
<!-- Progress data will be loaded here -->
</tbody>
</table>
</div>

## Key Milestones

- **February 2023**: Started lessons, couldn't go past 15m mark
- **May 2023**: First time diving into deep end with coach support  
- **July 2023**: Returned after break, building consistency at 25m laps
- **August 2023**: Major breakthrough - 35m laps, 700m total sessions
- **Ongoing**: Building endurance and improving technique

## Current Goals

- Increase session distance to 1000m
- Master treading water in deep end
- Improve breathing technique for longer freestyle stretches
- Build confidence for open water swimming

---

<script>
// Load and display CSV data
async function loadSwimmingProgress() {
    try {
        const response = await fetch('/data/swimming-progress.csv');
        const csvText = await response.text();
        
        const rows = csvText.trim().split('\n').slice(1); // Skip header
        const tableBody = document.getElementById('progress-data');
        
        rows.forEach(row => {
            // Parse CSV row (handle quotes and commas)
            const cols = row.match(/(".*?"|[^",\s]+)(?=\s*,|\s*$)/g);
            if (cols && cols.length >= 3) {
                const tr = document.createElement('tr');
                
                // Clean up quoted values
                const date = cols[0].replace(/"/g, '');
                const distance = cols[1].replace(/"/g, '');
                const details = cols[2].replace(/"/g, '');
                
                tr.innerHTML = `
                    <td><strong>${date}</strong></td>
                    <td>${distance}</td>
                    <td>${details}</td>
                `;
                
                tableBody.appendChild(tr);
            }
        });
    } catch (error) {
        console.error('Error loading swimming progress:', error);
        document.getElementById('progress-data').innerHTML = 
            '<tr><td colspan="3"><em>Unable to load progress data</em></td></tr>';
    }
}

// Load data when page loads
document.addEventListener('DOMContentLoaded', loadSwimmingProgress);
</script>

<style>
#swimming-progress {
    margin: 2rem 0;
}

#progress-table {
    width: 100%;
    border-collapse: collapse;
    margin: 1rem 0;
    font-size: 0.9rem;
}

#progress-table th,
#progress-table td {
    border: 1px solid #ddd;
    padding: 0.75rem;
    text-align: left;
    vertical-align: top;
}

#progress-table th {
    background-color: #f5f5f5;
    font-weight: 600;
    color: #333;
}

#progress-table tr:nth-child(even) {
    background-color: #f9f9f9;
}

#progress-table tr:hover {
    background-color: #f0f8ff;
}

/* Dark mode styles */
.dark #progress-table th {
    background-color: #374151;
    color: #f3f4f6;
    border-color: #4b5563;
}

.dark #progress-table td {
    border-color: #4b5563;
    color: #e5e7eb;
}

.dark #progress-table tr:nth-child(even) {
    background-color: #1f2937;
}

.dark #progress-table tr:hover {
    background-color: #374151;
}
</style>