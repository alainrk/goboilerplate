package main

import "testing"

func Add(a, b int) int {
	return a + b
}

func TestAdd(t *testing.T) {
	got := Add(2, 3)
	want := 5

	if got != want {
		t.Errorf("Add(2, 3) = %d; want %d", got, want)
	}
}

func TestAddTable(t *testing.T) {
	tests := []struct {
		name string
		a, b int
		want int
	}{
		{"positive", 2, 3, 5},
		{"zero", 0, 0, 0},
		{"negative", -1, -2, -3},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			got := Add(tt.a, tt.b)
			if got != tt.want {
				t.Errorf("Add(%d, %d) = %d; want %d", tt.a, tt.b, got, tt.want)
			}
		})
	}
}
