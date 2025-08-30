import React from 'react';
import ReactDOM from 'react-dom/client';
import { QueryClient, QueryClientProvider } from '@tanstack/react-query';
import { ReactQueryDevtools } from '@tanstack/react-query-devtools';
import { BrowserRouter } from 'react-router-dom';
import App from './App';
import './index.css';
import { AuthProvider } from './hooks/useAuth';
import { Toaster } from "@/components/ui/sonner";

// Create a single QueryClient instance that will be shared across the entire app
const queryClient = new QueryClient({
  defaultOptions: {
    queries: {
      // Reasonable defaults for your app
      staleTime: 1000 * 60 * 5, // 5 minutes
      gcTime: 1000 * 60 * 10, // 10 minutes (formerly cacheTime)
      retry: 1,
      refetchOnWindowFocus: false, // You can set to true if you want
    },
    mutations: {
      retry: 0, // Don't retry mutations by default
    },
  },
});

ReactDOM.createRoot(document.getElementById('root')!).render(
  <React.StrictMode>
    {/* CRITICAL: QueryClientProvider must wrap everything that uses React Query */}
    <QueryClientProvider client={queryClient}>
      {/* BrowserRouter should also wrap your app for React Router to work */}
      <BrowserRouter>
        <AuthProvider>
          <App />
          <Toaster />
        </AuthProvider>
      </BrowserRouter>
      {/* Optional but highly recommended for debugging */}
      <ReactQueryDevtools initialIsOpen={false} />
    </QueryClientProvider>
  </React.StrictMode>,
);