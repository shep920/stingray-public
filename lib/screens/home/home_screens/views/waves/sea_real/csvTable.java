package types;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.StringJoiner;

public class CSVTable implements Table {

    public record Pair(Object key, List<Object> row) {}

    private static final Path root = Paths.get("data", "tables");
    private final Path csv;

    public CSVTable(String name) {
    	try {
    		Files.createDirectories(root);
    		this.csv = root.resolve(name + ".csv");
    		if (!Files.exists(csv)) {
    			Files.createFile(csv);
    		}
    	} catch (IOException e) {
    		throw new IllegalStateException("Failed to create CSV table", e);
    	}
    }


    @Override
    public void clear() {
    	try {
    		Files.deleteIfExists(csv);
    		Files.createFile(csv);
    	} catch (IOException e) {
    		throw new IllegalStateException("Failed to clear CSV table", e);
    	}
    }
    
    @Override
    public List<Object> put(Object key, List<Object> row) {
    	List<String> lines = readAllLines();
    	if (!lines.isEmpty()) {
    		List<Object> firstRow = decodeRecord(lines.get(0)).row();
    		if (row.size() != firstRow.size()) {
    			throw new IllegalArgumentException("Row width mismatch");
    		}
    	}
    	String newRecord = encodeRecord(new Pair(key, row));
    	for (int i = 0; i < lines.size(); i++) {
    		Pair pair = decodeRecord(lines.get(i));
    		if (pair.key().equals(key)) {
    			lines.remove(i);
    			lines.add(0, newRecord);
    			writeAllLines(lines);
    			return pair.row();
    		}
    	}
    	lines.add(0, newRecord);
    	writeAllLines(lines);
    	return null;
    }

    @Override
    public List<Object> get(Object key) {
    	List<String> lines = readAllLines();
    	for (int i = 0; i < lines.size(); i++) {
    		Pair pair = decodeRecord(lines.get(i));
    		if (pair.key().equals(key)) {
    			lines.remove(i);
    			lines.add(0, encodeRecord(pair));
    			writeAllLines(lines);
    			return pair.row();
    		}
    	}
    	return null;
    }

    @Override
    public List<Object> remove(Object key) {
    	List<String> lines = readAllLines();
    	for (int i = 0; i < lines.size(); i++) {
    		Pair pair = decodeRecord(lines.get(i));
    		if (pair.key().equals(key)) {
    			lines.remove(i);
    			writeAllLines(lines);
    			return pair.row();
    		}
    	}
    	return null;
    }

    @Override
    public boolean containsKey(Object key) {
    	List<String> lines = readAllLines();
    	for (int i = 0; i < lines.size(); i++) {
    		Pair pair = decodeRecord(lines.get(i));
    		if (pair.key().equals(key)) {
    			return true;
    		}
    	}
    	return false;
    }

    @Override
    public boolean containsValue(Object row) {
        throw new UnsupportedOperationException();
    }

    @Override
    public int width() {
    	List<String> lines = readAllLines();
    	if (!lines.isEmpty()) {
    		List<Object> firstRow = decodeRecord(lines.get(0)).row();
    		return firstRow.size();
    	}
    	return 0;
    }

    @Override
    public int size() {
    	List<String> lines = readAllLines();
    	return lines.size();
    }

    @Override
    public boolean isEmpty() {
    	List<String> lines = readAllLines();
    	return lines.isEmpty();
    }

    @Override
    public double loadFactor() {
        return 1.0;
    }

    @Override
    public int hashCode() {
    	List<String> lines = readAllLines();
    	int sum = 0;
    	for (int i = 0; i < lines.size(); i++) {
    		Pair pair = decodeRecord(lines.get(i));
    		sum += pair.hashCode();
    	}
    	return sum;
    }

    @Override
    public boolean equals(Object obj) {
    	if (obj instanceof Table) {
    		Table table = (Table) obj;
    		if (this.size() == table.size()) {
    			List<String> lines = readAllLines();
    			for (int i = 0; i < lines.size(); i++) {
    				Pair pair = decodeRecord(lines.get(i));
    				if (!table.containsKey(pair.key())) {
    					return false;
    				}
    				if (!table.get(pair.key()).equals(pair.row())) {
    					return false;
    				}
    			}
    			return true;
    		}
    	}
    	return false;
    }

    @Override
    public Iterator<Object> iterator() {
    	List<String> lines = readAllLines();
    	List<Object> keys = new ArrayList<>();
    	for (int i = 0; i < lines.size(); i++) {
    		Pair pair = decodeRecord(lines.get(i));
    		keys.add(pair.key());
    	}
    	return keys.iterator();
    }

    @Override
    public String toString() {
        List<Object> sortedKeys = new ArrayList<>();
        Iterator<Object> iterator = iterator();
        while (iterator.hasNext()) {
            sortedKeys.add(iterator.next());
        }
        
        Collections.sort(sortedKeys, Comparator.comparing(obj -> obj.toString()));
        
        
        StringBuilder sb = new StringBuilder();  
        sb.append("+").append("-".repeat(10)); 
        for (int i = 0; i < width; i++) {
            sb.append("+").append("-".repeat(width+2)); 
        }
        sb.append("-+"); 
        sb.append(System.lineSeparator());


        sb.append("| Key      |"); 
        for (int i = 0; i < width; i++) {
            sb.append(" Value ").append(i).append(" |"); 
        }
        sb.append(System.lineSeparator());


        
        sb.append("+----------"); 
        
        for (int i = 0; i < width; i++) {
            sb.append("+").append("-".repeat(width+2)); 
        }
        sb.append("+");
        sb.append(System.lineSeparator());

        for (Pair pair : array) {
            if (pair == null) { 
                continue;
            }
            String key = (pair.key != null) ? pair.key.toString() : "";
            key = key.length() > width ? key.substring(0, width-3) + "..." : key;
            sb.append("| ").append(String.format("%-9s", key)).append("|"); // left-align key column

            for (int i = 0; i < pair.row.size(); i++) {
                String value = pair.row.get(i) != null ? pair.row.get(i).toString() : "";
                value = value.length() > width ? value.substring(0, width-3) + "..." : value;
                if (value.isEmpty()) {
                    sb.append(String.format("%" + (width+1) + "s", "|")); // right-align empty value
                } else {
                    sb.append(String.format("%-" + (width+1) + "s", String.format("| %-" + width + "s", value))); // left-align non-numeric value
                }
            }
            sb.append(System.lineSeparator());
        }

        
        sb.append("+").append("-".repeat(10)); 
        for (int i = 0; i < width; i++) {
            sb.append("+").append("-".repeat(width+2)); 
        }
        sb.append("+");
        return sb.toString();
    }

    //A public toString method which returns an unsorted pretty-formatted tabular view of the table (like in previous modules).
//1 Label the view with the flat file name above the header, excluding the root directories but including the extension.
public String toString() {
    StringBuilder sb = new StringBuilder();
    sb.append("Table: ").append(csv.getFileName()).append(System.lineSeparator());
    sb.append("+").append("-".repeat(10));
    for (int i = 0; i < width; i++) {
        sb.append("+").append("-".repeat(width+2));
    }
    sb.append("-+").append(System.lineSeparator());
    sb.append("| Key      |");
    for (int i = 0; i < width; i++) {
        sb.append(" Value ").append(i).append(" |");
    }
    sb.append(System.lineSeparator());
    sb.append("+----------");
    for (int i = 0; i < width; i++) {
        sb.append("+").append("-".repeat(width+2));
    }
    sb.append("+").append(System.lineSeparator());
    for (Pair pair : array) {
        if (pair == null) {
            continue;
        }
        String key = (pair.key != null) ? pair.key.toString() : "";
        key = key.length() > width ? key.substring(0, width-3) + "..." : key;
        sb.append("| ").append(String.format("%-9s", key)).append("|");
        for (int i = 0; i < pair.row.size(); i++) {
            String value = pair.row.get(i) != null ? pair.row.get(i).toString() : "";
            value = value.length() > width ? value.substring(0, width-3) + "..." : value;
            if (value.isEmpty()) {
                sb.append(String.format("%" + (width+1) + "s", "|"));
            } else {
                sb.append(String.format("%-" + (width+1) + "s", String.format("| %-" + width + "s", value)));
            }
        }
        sb.append(System.lineSeparator());
    }
    sb.append("+").append("-".repeat(10));
    for (int i = 0; i < width; i++) {
        sb.append("+").append("-".repeat(width+2));
    }
    sb.append("+");
    return sb.toString();
}


    
    
    public List<String> readAllLines() {
        try {
            return Files.readAllLines(csv);
        } catch (IOException e) {
            throw new IllegalStateException("Failed to read CSV file", e);
        }
    }
    
    public void writeAllLines(List<String> lines) {
        try {
            Files.write(csv, lines);
        } catch (IOException e) {
            throw new IllegalStateException("Failed to write CSV file", e);
        }
    }
    
    public boolean exists() {
        return Files.exists(csv);
    }
    
    public void createFile() {
        try {
            Files.createFile(csv);
        } catch (IOException e) {
            throw new IllegalStateException("Failed to create CSV file", e);
        }
    }
    
    public void deleteFile() {
        try {
            Files.deleteIfExists(csv);
        } catch (IOException e) {
            throw new IllegalStateException("Failed to delete CSV file", e);
        }
    }

	@Override
	public int capacity() {
    	return size();
    }
	
	public static String encodeField(Object obj) {
		if (obj == null) {
			return "null";
		} else if (obj instanceof String) {
			return "\"" + obj + "\"";
		} else if (obj instanceof Boolean || obj instanceof Integer || obj instanceof Float || obj instanceof Double) {
			return obj.toString();
		} else {
			throw new IllegalArgumentException("Unsupported object type: " + obj.getClass().getSimpleName());
		}
	}
	
	public static Object decodeField(String field) {
	    if (field.equalsIgnoreCase("null")) {
	        return null;
	    } else if (field.startsWith("\"") && field.endsWith("\"")) {
	        return field.substring(1, field.length() - 1);
	    } else if (field.equalsIgnoreCase("true")) {
	        return true;
	    } else if (field.equalsIgnoreCase("false")) {
	        return false;
	    } else {
	        try {
	            return Integer.parseInt(field);
	        } catch (NumberFormatException e) {
	            // field is not an integer
	        }

	        try {
	            return Double.parseDouble(field);
	        } catch (NumberFormatException e) {
	            // field is not a double
	        }

	        throw new IllegalArgumentException("Unrecognized field: " + field);
	    }
	}
	
	public static String encodeRecord(Pair pair) {
	    StringJoiner joiner = new StringJoiner(",");
	    joiner.add(encodeField(pair.key()));
	    for (Object value : pair.row()) {
	        joiner.add(encodeField(value));
	    }
	    return joiner.toString();
	}
	
	
	
	
	public static Pair decodeRecord(String record) {
	    String[] fields = record.split(",");
	    Object key = (decodeField(fields[0]));
	    if(key instanceof String) {
	    	key = ((String) key).trim();
	    }
	    
	    
	    
	    List<Object> row = new ArrayList<>();
	    for (int i = 1; i < fields.length; i++) {
	    	Object value = (decodeField(fields[0]));
		    if(value instanceof String) {
		    	value = ((String) value).trim();
		    }
	        row.add(value);
	    }
	    return new Pair(key, row);
	}
   
}
