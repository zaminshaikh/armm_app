/**
 * Rounds the given Date to the nearest hour.
 */
/**
 * Rounds the provided Date instance to the nearest hour.
 *
 * This function evaluates the minutes portion of the given date. If the minutes
 * are 30 or greater, it rounds up to the next hour; otherwise, it keeps the current hour.
 * In both cases, it resets the minutes, seconds, and milliseconds to zero.
 *
 * @param date - The original Date object to round.
 * @returns A new Date object representing the original time rounded to the nearest hour.
 */
export const roundToNearestHour = (date: Date): Date => {
    const minutes = date.getMinutes();
    const roundedDate = new Date(date);
    if (minutes >= 30) {
      roundedDate.setHours(date.getHours() + 1);
    }
    roundedDate.setMinutes(0, 0, 0);
    return roundedDate;
};

/**
 * Formats a number as a currency string.
 *
 * This function takes a number as input and returns a string that represents
 * the number formatted as a currency in US dollars. The formatting is done
 * using the built-in `Intl.NumberFormat` object with 'en-US' locale and 'USD'
 * as the currency.
 *
 * @param amount - The number to be formatted as currency.
 * @returns The formatted currency string.
 *
 * @example
 * ```typescript
 * const amount = 1234.56;
 * const formattedAmount = formatCurrency(amount);
 * ```
 */
export const formatCurrency = (amount: number): string => {
return new Intl.NumberFormat('en-US', { style: 'currency', currency: 'USD' }).format(amount);
};