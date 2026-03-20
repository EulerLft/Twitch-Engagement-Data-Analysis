# -*- coding: utf-8 -*-
"""
Created on Fri Mar 20 12:21:09 2026

@author: salva
"""

import pandas as pd
import seaborn as sns
import matplotlib.pyplot as plt
import matplotlib.ticker as ticker

# 1. Load the data
df = pd.read_csv('twitch_hourly_engagement.csv')

# 2. Calculate the Chat-to-Viewer Ratio
# This helps see 'Engagement Efficiency' regardless of total volume
df['chat_ratio'] = df['chatters'] / df['viewers']

# 3. Create a dual-insight visualization
fig, (ax1, ax2) = plt.subplots(2, 1, figsize=(10, 12))

# Top Plot: Actual Counts (Total Volume)
sns.lineplot(data=df, x='hour', y='viewers', label='Total Viewers', ax=ax1, marker='o')
sns.lineplot(data=df, x='hour', y='chatters', label='Total Chatters', ax=ax1, marker='o')
ax1.set_title('Hourly Viewership vs. Chat Activity')
ax1.set_ylabel('Count')

# Formatting Top Plot Y-Axis with commas (e.g., 30,000)
ax1.get_yaxis().set_major_formatter(ticker.FuncFormatter(lambda x, p: format(int(x), ',')))

# Bottom Plot: The Ratio (Engagement Intensity)
sns.barplot(data=df, x='hour', y='chat_ratio', palette='viridis', ax=ax2)
ax2.set_title('Social Engagement Intensity (Chatters per Viewer)')
ax2.set_ylabel('Ratio')

# Aligning X-Axis Ticks for both plots
for ax in [ax1, ax2]:
    ax.set_xticks(range(24))
    ax.set_xlabel('Hour of Day (UTC)')

plt.tight_layout()
plt.show()

plt.savefig('twitch_viewership_vs_engagement_trends.png')